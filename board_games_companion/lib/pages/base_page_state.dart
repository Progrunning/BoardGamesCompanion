import 'package:flutter/material.dart';

import '../common/analytics.dart';
import '../common/app_colors.dart';
import '../common/app_text.dart';
import '../common/dimensions.dart';
import '../injectable.dart';
import '../services/analytics_service.dart';
import '../services/engagement_prompt_session_guard.dart';
import '../services/rate_and_review_service.dart';
import '../services/support_prompt_service.dart';
import 'tip/tip_page.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  late RateAndReviewService rateAndReviewService;
  late SupportPromptService supportPromptService;
  late AnalyticsService analyticsService;

  @override
  void initState() {
    super.initState();

    rateAndReviewService = getIt<RateAndReviewService>();
    supportPromptService = getIt<SupportPromptService>();
    analyticsService = getIt<AnalyticsService>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // MK At most one engagement prompt (rate & review or support) may be
      // shown per app session, so the app never stacks asks.
      if (EngagementPromptSessionGuard.promptShownThisSession) {
        return;
      }

      if (rateAndReviewService.showRateAndReviewDialog) {
        // MK Wait for all of the animations to finish before showing the dialog
        await Future<dynamic>.delayed(const Duration(seconds: 1));

        EngagementPromptSessionGuard.promptShownThisSession = true;

        // ignore: use_build_context_synchronously
        await _showRateAndReviewDialog(context);
        return;
      }

      if (supportPromptService.showSupportPromptDialog) {
        // MK Wait for all of the animations to finish before showing the dialog
        await Future<dynamic>.delayed(const Duration(seconds: 1));

        await supportPromptService.promptShown();
        await analyticsService.logEvent(name: Analytics.viewSupportPrompt);

        // ignore: use_build_context_synchronously
        await _showSupportPromptDialog(context);
      }
    });
  }

  Future<void> _showRateAndReviewDialog(BuildContext context) async {
    await _showEngagementPromptDialog(
      context,
      title: AppText.rateAndReview,
      content: const <Widget>[
        Text("We apologise that we're interupting you but we would really appreciate your support.\n"),
        Text(
            "If you're enjoying ${AppText.appTitle} app, would you mind taking a moment to rate it? It shouldn't take more than a minute.\n"),
        Text('Thank you.'),
      ],
      onDismissForever: () async => rateAndReviewService.dontAskAgain(),
      onAskMeLater: () async => rateAndReviewService.askMeLater(),
      positiveText: AppText.rate,
      onPositive: () async => rateAndReviewService.requestReview(),
    );
  }

  Future<void> _showSupportPromptDialog(BuildContext context) async {
    await _showEngagementPromptDialog(
      context,
      title: AppText.supportPromptTitle,
      content: const <Widget>[
        Text(AppText.supportPromptMessage),
      ],
      onDismissForever: () async {
        await supportPromptService.dontAskAgain();
        await analyticsService.logEvent(name: Analytics.supportPromptNeverAskAgain);
      },
      onAskMeLater: () async {
        await supportPromptService.askMeLater();
        await analyticsService.logEvent(name: Analytics.supportPromptRemindMeLater);
      },
      positiveText: AppText.supportPromptTip,
      onPositive: () async {
        await supportPromptService.tip();
        await analyticsService.logEvent(name: Analytics.supportPromptTip);

        if (!mounted) {
          return;
        }
        await Navigator.of(this.context).pushNamed(TipPage.pageRoute);
      },
    );
  }

  /// The one shape every engagement prompt shares: a non-dismissible dialog
  /// with "don't ask again" / "ask me later" text actions and a single
  /// filled positive action.
  Future<void> _showEngagementPromptDialog(
    BuildContext context, {
    required String title,
    required List<Widget> content,
    required Future<void> Function() onDismissForever,
    required Future<void> Function() onAskMeLater,
    required String positiveText,
    required Future<void> Function() onPositive,
  }) async {
    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
          elevation: Dimensions.defaultElevation,
          actions: [
            TextButton(
              child: const Text(
                AppText.aontAskAgain,
                style: TextStyle(color: AppColors.accentColor),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await onDismissForever();
              },
            ),
            TextButton(
              child: const Text(
                AppText.askMeLater,
                style: TextStyle(color: AppColors.accentColor),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await onAskMeLater();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.accentColor),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await onPositive();
              },
              child: Text(
                positiveText,
                style: const TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
