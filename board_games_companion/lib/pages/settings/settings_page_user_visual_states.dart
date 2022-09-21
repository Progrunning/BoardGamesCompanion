import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page_user_visual_states.freezed.dart';

@freezed
class SettingsPageUserVisualState with _$SettingsPageUserVisualState {
  const factory SettingsPageUserVisualState.noUser() = NoUser;
  const factory SettingsPageUserVisualState.user() = User;
}
