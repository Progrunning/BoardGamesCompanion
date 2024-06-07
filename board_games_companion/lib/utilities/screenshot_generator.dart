// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/analytics.dart';
import 'package:board_games_companion/common/app_colors.dart';
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

import '../common/app_styles.dart';
import '../common/dimensions.dart';
import '../models/hive/board_game_details.dart';
import '../widgets/board_games/board_game_tile.dart';
import 'screenshot_generator_visual_state.dart';

part 'screenshot_generator.g.dart';

@singleton
class ScreenshotGenerator = _ScreenshotGenerator with _$ScreenshotGenerator;

abstract class _ScreenshotGenerator with Store {
// TODO
  // E/DatabaseUtils(19745): java.lang.SecurityException: Permission Denial: writing dev.fluttercommunity.plus.share.ShareFileProvider uri content://com.progrunning.boardgamescompanion.flutter.share_provider/cache/image.png from pid=21055, uid=10161 requires the provider be exported, or grantUriPermission()

  // The image would need to be save prior to sharing, in order to manipulate it in a different activity (e.g. google photos edit)
  // https://stackoverflow.com/questions/30572261/using-data-from-context-providers-or-requesting-google-photos-read-permission/30909105#30909105
  // https://github.com/MertcanDinler/Flutter-Advanced-Share/issues/2

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
    List<BoardGameDetails> boardGames, [
    int numberOfColumns = 5,
  ]) async {
    if (boardGames.isEmpty) {
      Fimber.i('Cannot generate a screenshot from an empty list of board games');
      return;
    }

    unawaited(_rateAndReviewService.increaseNumberOfSignificantActions());
    unawaited(_analyticsService.logEvent(name: Analytics.shareCollectionScreenshot));

    try {
      await _downloadGameThumbnails(boardGames);

      final boardGamesInRows = <List<BoardGameDetails>>[];
      for (var i = 0; i < boardGames.length; i += numberOfColumns) {
        boardGamesInRows.add(
          boardGames.sublist(
            i,
            i + numberOfColumns > boardGames.length ? boardGames.length : i + numberOfColumns,
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

          final directory = await getApplicationDocumentsDirectory();
          final screenshotFile = await File('${directory.path}/image.png').create();
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
  Widget build(BuildContext context) {
    return Container(
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
                            right:
                                boardGamesInRow.last == boardGame ? 0 : Dimensions.standardSpacing,
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
            ],
          ),
        ),
      ),
    );
  }
}
