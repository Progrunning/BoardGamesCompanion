import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Identifiers for the app icons a user can choose between.
///
/// [defaultIcon] is always available and matches the app's shipped launcher
/// icon. Further ids correspond to platform-registered alternate icons —
/// an Android `activity-alias` entry, or an iOS `CFBundleAlternateIcons`
/// entry — that [AppIconService] can switch to.
abstract class AppIconIds {
  static const String defaultIcon = 'default';

  /// The Supporter cosmetic-perk alternate icon (issue #331). Currently a
  /// placeholder: it reuses the default launcher artwork duplicated under a
  /// new name so the picker/platform wiring can be built and tested ahead
  /// of real alternate-icon artwork being designed.
  static const String supporter = 'supporter';
}

/// Abstracts the platform-native mechanism for switching the app's home
/// screen icon behind a single seam, so the rest of the app never talks to
/// platform channels directly.
///
/// This is a thin pass-through wrapper, mirroring [RevenueCatClient]'s
/// seam pattern (see `revenue_cat_client.dart`): it is not unit tested,
/// per the seam decision in issue #297. Only its consumers (the app icon
/// picker view model) are tested, via a mocked [AppIconService].
abstract class AppIconService {
  /// The icon ids available to switch to on the current platform,
  /// including [AppIconIds.defaultIcon].
  Future<List<String>> getAvailableIconIds();

  /// Applies the platform's native icon-switching mechanism to change the
  /// app's home screen icon to [iconId].
  Future<void> setIcon(String iconId);

  /// The id of the icon currently applied.
  Future<String> getCurrentIconId();
}

/// [AppIconService] implementation backed by a thin `MethodChannel` to
/// native platform code (Android `activity-alias` swapping in
/// `MainActivity.kt`; iOS `UIApplication.setAlternateIconName` glue in
/// `AppDelegate.swift`).
@LazySingleton(as: AppIconService)
class PlatformAppIconService implements AppIconService {
  static const MethodChannel _channel =
      MethodChannel('com.progrunning.boardgamescompanion/app_icon');

  @override
  Future<List<String>> getAvailableIconIds() async {
    final List<Object?>? result =
        await _channel.invokeMethod<List<Object?>>('getAvailableIconIds');
    return result?.cast<String>() ?? const <String>[AppIconIds.defaultIcon];
  }

  @override
  Future<void> setIcon(String iconId) => _channel.invokeMethod<void>(
        'setIcon',
        <String, String>{'iconId': iconId},
      );

  @override
  Future<String> getCurrentIconId() async {
    final String? result = await _channel.invokeMethod<String>('getCurrentIconId');
    return result ?? AppIconIds.defaultIcon;
  }
}
