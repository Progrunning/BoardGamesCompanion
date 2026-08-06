import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Thin platform-channel wrapper backing `AppIconService`
  // (lib/services/app_icon_service.dart) — a cosmetic Supporter perk
  // (issue #331) that lets a Supporter choose an alternate home screen
  // icon. This is a deliberate pass-through to
  // UIApplication.setAlternateIconName and is not unit tested, mirroring
  // the seam decision already applied to `RevenueCatClient` on the Dart
  // side.
  private let appIconChannelName = "com.progrunning.boardgamescompanion/app_icon"
  private let defaultIconId = "default"
  private let supporterIconId = "supporter"
  private let supporterAlternateIconName = "AppIconSupporter"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let appIconChannel = FlutterMethodChannel(
        name: appIconChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      appIconChannel.setMethodCallHandler { [weak self] call, result in
        self?.handleAppIconMethodCall(call, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleAppIconMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAvailableIconIds":
      result([defaultIconId, supporterIconId])
    case "getCurrentIconId":
      result(UIApplication.shared.alternateIconName == supporterAlternateIconName
        ? supporterIconId
        : defaultIconId)
    case "setIcon":
      let arguments = call.arguments as? [String: Any]
      let iconId = arguments?["iconId"] as? String
      let alternateIconName = iconId == supporterIconId ? supporterAlternateIconName : nil

      guard UIApplication.shared.supportsAlternateIcons else {
        result(nil)
        return
      }

      UIApplication.shared.setAlternateIconName(alternateIconName) { _ in
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
