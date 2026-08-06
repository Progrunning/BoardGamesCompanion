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
    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.rateAndReview),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "We apologise that we're interupting you but we would really appreciate your support.\n"),
              Text(
                  "If you're enjoying ${AppText.appTitle} app, would you mind taking a moment to rate it? It shouldn't take more than a minute.\n"),
              Text('Thank you.'),
            ],
          ),
          elevation: Dimensions.defaultElevation,
          actions: [
            TextButton(
              child: const Text(
                AppText.aontAskAgain,
                style: TextStyle(
                  color: AppColors.accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.dontAskAgain();
              },
            ),
            TextButton(
              child: const Text(
                AppText.askMeLater,
                style: TextStyle(
                  color: AppColors.accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.askMeLater();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.accentColor),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.requestReview();
              },
              child: const Text(
                AppText.rate,
                style: TextStyle(
                  color: AppColors.defaultTextColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSupportPromptDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.supportPromptTitle),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppText.supportPromptMessage),
            ],
          ),
          elevation: Dimensions.defaultElevation,
          actions: [
            TextButton(
              child: const Text(
                AppText.aontAskAgain,
                style: TextStyle(
                  color: AppColors.accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await supportPromptService.dontAskAgain();
                await analyticsService.logEvent(name: Analytics.supportPromptNeverAskAgain);
              },
            ),
            TextButton(
              child: const Text(
                AppText.askMeLater,
                style: TextStyle(
                  color: AppColors.accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await supportPromptService.askMeLater();
                await analyticsService.logEvent(name: Analytics.supportPromptRemindMeLater);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.accentColor),
              onPressed: () async {
                Navigator.of(context).pop();

                await supportPromptService.tip();
                await analyticsService.logEvent(name: Analytics.supportPromptTip);

                // ignore: use_build_context_synchronously
                await Navigator.of(context).pushNamed(TipPage.pageRoute);
              },
              child: const Text(
                AppText.supportPromptTip,
                style: TextStyle(
                  color: AppColors.defaultTextColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
