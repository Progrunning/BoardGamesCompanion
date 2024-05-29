// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/app_colors.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../common/app_styles.dart';
import '../common/dimensions.dart';
import '../models/hive/board_game_details.dart';
import '../widgets/board_games/board_game_tile.dart';
import 'games_screenshot_generator_state.dart';

part 'games_screenshot_generator.g.dart';

@singleton
class GamesScreenshotGenerator = _GamesScreenshotGenerator with _$GamesScreenshotGenerator;

abstract class _GamesScreenshotGenerator with Store {
// TODO
  // E/DatabaseUtils(19745): java.lang.SecurityException: Permission Denial: writing dev.fluttercommunity.plus.share.ShareFileProvider uri content://com.progrunning.boardgamescompanion.flutter.share_provider/cache/image.png from pid=21055, uid=10161 requires the provider be exported, or grantUriPermission()

  // The image would need to be save prior to sharing, in order to manipulate it in a different activity (e.g. google photos edit)
  // https://stackoverflow.com/questions/30572261/using-data-from-context-providers-or-requesting-google-photos-read-permission/30909105#30909105
  // https://github.com/MertcanDinler/Flutter-Advanced-Share/issues/2

  _GamesScreenshotGenerator({
    required ScreenshotController screenshotController,
  }) : _screenshotController = screenshotController;

  final ScreenshotController _screenshotController;

  @observable
  GamesScreenshotGeneratorState gamesScreenshotGeneratorState =
      const GamesScreenshotGeneratorState.init();

  @action
  Future<void> generateScreenshot(
    List<BoardGameDetails> boardGames, [
    int numberOfColumns = 5,
  ]) async {
    if (boardGames.isEmpty) {
      Fimber.i('Cannot generate a screenshot from an empty list of board games');
      return;
    }

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

      gamesScreenshotGeneratorState = const GamesScreenshotGeneratorState.generatingScreenshot();

      final gamesSpacingWidth = (numberOfColumns + 1) * Dimensions.standardSpacing;
      final gamesWidth =
          Dimensions.boardGameItemCollectionImageWidth * numberOfColumns + gamesSpacingWidth;

      // TODO Extract to a method and add retry
      final screenshot = await _screenshotController.captureFromLongWidget(
        Container(
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
                        bottom: boardGamesInRows.last == boardGamesInRow
                            ? 0
                            : Dimensions.standardSpacing,
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
                ],
              ),
            ),
          ),
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final screenshotFile = await File('${directory.path}/image.png').create();
      await screenshotFile.writeAsBytes(screenshot);

      gamesScreenshotGeneratorState =
          GamesScreenshotGeneratorState.generated(screenshotFile: screenshotFile);

      return;
    } on Exception catch (ex, stacktrace) {
      Fimber.e('Failed to generate a screenshot', ex: ex, stacktrace: stacktrace);
    }

    gamesScreenshotGeneratorState = const GamesScreenshotGeneratorState.generationFailure();
  }

  Future<void> _downloadGameThumbnails(List<BoardGameDetails> boardGames) async {
    for (final boardGame in boardGames) {
      if (boardGame.thumbnailUrl.isNullOrBlank) {
        Fimber.i('Board game ${boardGame.name} lack a thumbnail, skipping');
        continue;
      }

      final downloadProgress = ((boardGames.indexOf(boardGame) / boardGames.length) * 100).toInt();
      gamesScreenshotGeneratorState =
          GamesScreenshotGeneratorState.downloadingImages(progressPercentage: downloadProgress);
      Fimber.i('Download progress $downloadProgress%...');

      // Download all of the game thumbnails for the rendering pruposes
      // https://pub.dev/packages/flutter_cache_manager
      await DefaultCacheManager().downloadFile(boardGame.thumbnailUrl!);
    }
  }
}
