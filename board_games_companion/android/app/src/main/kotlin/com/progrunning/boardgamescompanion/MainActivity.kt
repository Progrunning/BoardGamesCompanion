package com.progrunning.boardgamescompanion

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Thin platform-channel wrapper backing `AppIconService`
// (lib/services/app_icon_service.dart) — a cosmetic Supporter perk
// (issue #331) that lets a Supporter choose an alternate home screen icon.
// This class is a deliberate pass-through to Android's activity-alias
// icon-switching mechanism and is not unit tested, mirroring the seam
// decision already applied to `RevenueCatClient` on the Dart side.
class MainActivity : FlutterActivity() {
    private val appIconChannelName = "com.progrunning.boardgamescompanion/app_icon"

    private val defaultIconId = "default"
    private val supporterIconId = "supporter"

    private val mainActivityComponentName by lazy {
        ComponentName(applicationContext, "$packageName.MainActivity")
    }
    private val supporterAliasComponentName by lazy {
        ComponentName(applicationContext, "$packageName.SupporterIconActivityAlias")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, appIconChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAvailableIconIds" -> result.success(listOf(defaultIconId, supporterIconId))
                    "getCurrentIconId" -> result.success(getCurrentIconId())
                    "setIcon" -> {
                        val iconId = call.argument<String>("iconId")
                        setIcon(iconId)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getCurrentIconId(): String {
        val aliasEnabled = packageManager.getComponentEnabledSetting(supporterAliasComponentName) ==
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED
        return if (aliasEnabled) supporterIconId else defaultIconId
    }

    private fun setIcon(iconId: String?) {
        val enableAlias = iconId == supporterIconId

        packageManager.setComponentEnabledSetting(
            supporterAliasComponentName,
            if (enableAlias) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
        packageManager.setComponentEnabledSetting(
            mainActivityComponentName,
            if (enableAlias) PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            else PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }
}
