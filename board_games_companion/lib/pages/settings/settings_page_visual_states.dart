import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page_visual_states.freezed.dart';

@freezed
class SettingsPageVisualState with _$SettingsPageVisualState {
  const factory SettingsPageVisualState.initial() = Initial;
  const factory SettingsPageVisualState.restoring() = Restoring;
  const factory SettingsPageVisualState.restoringCancelled() = RestoringCancelled;
  const factory SettingsPageVisualState.restoringSuccess() = RestoringSucceeded;
  const factory SettingsPageVisualState.restoringFailure([String? message]) = RestoringFailed;
}
