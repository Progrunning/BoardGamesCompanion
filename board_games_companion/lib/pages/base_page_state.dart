import 'package:flutter/material.dart';

import '../common/app_text.dart';
import '../common/app_theme.dart';
import '../common/dimensions.dart';
import '../injectable.dart';
import '../services/rate_and_review_service.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  late RateAndReviewService rateAndReviewService;

  @override
  void initState() {
    super.initState();

    rateAndReviewService = getIt<RateAndReviewService>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!rateAndReviewService.showRateAndReviewDialog) {
        return;
      }

      // MK Wait for all of the animations to finish before showing the dialog
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      // ignore: use_build_context_synchronously
      await _showRateAndReviewDialog(context);
    });
  }

  Future<void> _showRateAndReviewDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.rateAndReview),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                  "We apologise that we're interupting you but we would really appreciate your support.\n"),
              Text(
                  "If you're enjoying ${AppText.appTitle} app, would you mind taking a moment to rate it? It shouldn't take more than a minute.\n"),
              Text('Thank you.'),
            ],
          ),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(
                AppText.aontAskAgain,
                style: TextStyle(
                  color: AppTheme.accentColor,
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
                  color: AppTheme.accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.askMeLater();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppTheme.accentColor),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.requestReview();
              },
              child: const Text(
                AppText.rate,
                style: TextStyle(
                  color: AppTheme.defaultTextColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
