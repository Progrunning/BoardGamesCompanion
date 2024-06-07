import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'screenshot_generator_visual_state.freezed.dart';

@freezed
class ScreenshotGeneratorVisualState with _$ScreenshotGeneratorVisualState {
  const factory ScreenshotGeneratorVisualState.init() = _Init;
  const factory ScreenshotGeneratorVisualState.downloadingImages({
    required int progressPercentage,
  }) = _DownloadingImages;
  const factory ScreenshotGeneratorVisualState.generatingScreenshot() = _GeneratingScreenshot;
  const factory ScreenshotGeneratorVisualState.generated({
    required File screenshotFile,
  }) = _Generated;
  const factory ScreenshotGeneratorVisualState.generationFailure() = _GenerationFailure;
}
