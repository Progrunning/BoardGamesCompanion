import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'games_screenshot_generator_state.freezed.dart';

@freezed
class GamesScreenshotGeneratorState with _$GamesScreenshotGeneratorState {
  const factory GamesScreenshotGeneratorState.init() = _Init;
  const factory GamesScreenshotGeneratorState.downloadingImages({
    required int progressPercentage,
  }) = _DownloadingImages;
  const factory GamesScreenshotGeneratorState.generatingScreenshot() = _GeneratingScreenshot;
  const factory GamesScreenshotGeneratorState.generated({
    required File screenshotFile,
  }) = _Generated;
  const factory GamesScreenshotGeneratorState.generationFailure() = _GenerationFailure;
}
