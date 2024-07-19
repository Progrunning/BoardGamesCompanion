// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/analytics.dart';
import 'package:board_games_companion/common/app_colors.dart';
import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/services/analytics_service.dart';
import 'package:board_games_companion/services/rate_and_review_service.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retry/retry.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import '../common/app_styles.dart';
import '../common/dimensions.dart';
import '../models/hive/board_game_details.dart';
import '../widgets/board_games/board_game_tile.dart';
import 'screenshot_generator_visual_state.dart';

part 'screenshot_generator.g.dart';

@singleton
class ScreenshotGenerator = _ScreenshotGenerator with _$ScreenshotGenerator;

abstract class _ScreenshotGenerator with Store {
  _ScreenshotGenerator({
    required ScreenshotController screenshotController,
    required RateAndReviewService rateAndReviewService,
    required AnalyticsService analyticsService,
  })  : _screenshotController = screenshotController,
        _rateAndReviewService = rateAndReviewService,
        _analyticsService = analyticsService;

  final ScreenshotController _screenshotController;
  final RateAndReviewService _rateAndReviewService;
  final AnalyticsService _analyticsService;

  @observable
  ScreenshotGeneratorVisualState visualState = const ScreenshotGeneratorVisualState.init();

  @action
  Future<void> generateCollectionScreenshot(
    List<BoardGameDetails> baseBoardGames, [
    int numberOfColumns = 5,
  ]) async {
    if (baseBoardGames.isEmpty) {
      Fimber.i('Cannot generate a screenshot from an empty list of board games');
      return;
    }

    unawaited(_rateAndReviewService.increaseNumberOfSignificantActions());
    unawaited(_analyticsService.logEvent(name: Analytics.shareCollectionScreenshot));

    try {
      await _downloadGameThumbnails(baseBoardGames);

      final boardGamesInRows = <List<BoardGameDetails>>[];
      for (var i = 0; i < baseBoardGames.length; i += numberOfColumns) {
        boardGamesInRows.add(
          baseBoardGames.sublist(
            i,
            i + numberOfColumns > baseBoardGames.length
                ? baseBoardGames.length
                : i + numberOfColumns,
          ),
        );
      }

      visualState = const ScreenshotGeneratorVisualState.generatingScreenshot();

      final gamesSpacingWidth = (numberOfColumns + 1) * Dimensions.standardSpacing;
      final gamesWidth =
          Dimensions.boardGameItemCollectionImageWidth * numberOfColumns + gamesSpacingWidth;

      final screenshotFile = await _generateScreenshot(
        _GamesCollection(
          gamesWidth: gamesWidth,
          boardGamesInRows: boardGamesInRows,
        ),
      );
      if (screenshotFile != null) {
        visualState = ScreenshotGeneratorVisualState.generated(screenshotFile: screenshotFile);
      }

      return;
    } catch (e, stacktrace) {
      Fimber.e('Failed to generate a screenshot', ex: e, stacktrace: stacktrace);
    }

    visualState = const ScreenshotGeneratorVisualState.generationFailure();
  }

  Future<File?> _generateScreenshot(
    Widget screenshotWidget, [
    int numberOfRetries = 2,
  ]) async {
    return retry<File?>(
      () async {
        try {
          final screenshot = await _screenshotController.captureFromLongWidget(screenshotWidget);

          final directory = await getApplicationSupportDirectory();
          final screenshotFile =
              await File('${directory.path}/collection-${const Uuid().v4()}.png').create();
          await screenshotFile.writeAsBytes(screenshot);
          return screenshotFile;
        } catch (e, stacktrace) {
          // MK Capture an error and throw an exception so the retry mechanism can kick in
          //    The retry doesn't seem to like errors
          Fimber.e('Failed to generate a screenshot', ex: e, stacktrace: stacktrace);
          throw Exception();
        }
      },
      maxAttempts: numberOfRetries,
      maxDelay: Duration.zero,
      delayFactor: Duration.zero,
      retryIf: (_) => true,
      onRetry: (_) => Fimber.i('Retrying screenshot generation'),
    );
  }

  Future<void> _downloadGameThumbnails(List<BoardGameDetails> boardGames) async {
    for (final boardGame in boardGames) {
      if (boardGame.thumbnailUrl.isNullOrBlank) {
        Fimber.i('Board game ${boardGame.name} lack a thumbnail, skipping');
        continue;
      }

      final downloadProgress = ((boardGames.indexOf(boardGame) / boardGames.length) * 100).toInt();
      visualState =
          ScreenshotGeneratorVisualState.downloadingImages(progressPercentage: downloadProgress);
      Fimber.i('Download progress $downloadProgress%...');

      // Download all of the game thumbnails for the rendering pruposes
      // https://pub.dev/packages/flutter_cache_manager
      await DefaultCacheManager().downloadFile(boardGame.thumbnailUrl!);
    }
  }
}

class _GamesCollection extends StatelessWidget {
  const _GamesCollection({
    required this.gamesWidth,
    required this.boardGamesInRows,
  });

  final double gamesWidth;
  final List<List<BoardGameDetails>> boardGamesInRows;

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.primaryColorLight,
        child: SizedBox(
          width: gamesWidth,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final boardGamesInRow in boardGamesInRows)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          boardGamesInRows.last == boardGamesInRow ? 0 : Dimensions.standardSpacing,
                    ),
                    child: Row(
                      children: [
                        for (final boardGame in boardGamesInRow)
                          Padding(
                            padding: EdgeInsets.only(
                              right: boardGamesInRow.last == boardGame
                                  ? 0
                                  : Dimensions.standardSpacing,
                            ),
                            child: SizedBox(
                              width: Dimensions.boardGameItemCollectionImageWidth,
                              height: Dimensions.boardGameItemCollectionImageHeight,
                              child: BoardGameTile(
                                id: boardGame.id,
                                name: boardGame.name,
                                imageUrl: boardGame.thumbnailUrl ?? '',
                                rank: boardGame.rank,
                                elevation: AppStyles.defaultElevation,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                const _Logo(),
              ],
            ),
          ),
        ),
      );
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: Dimensions.doubleStandardSpacing,
        // MK Bottom is reduced because the entire container has padding
        //    which sums up to [Dimensions.doubleStandardSpacing]
        bottom: Dimensions.standardSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // TODO Replace this with SVG cause it's pixelated
          SizedBox(
            height: 40,
            width: 40,
            child: Image(image: AssetImage('assets/icons/adaptive_icon_foreground.png')),
          ),
          SizedBox(width: Dimensions.standardSpacing),
          Text(AppText.appTitle, style: AppTheme.titleTextStyle),
        ],
      ),
    );
  }
}
