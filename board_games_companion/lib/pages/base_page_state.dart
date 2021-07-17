import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/dimensions.dart';
import '../common/strings.dart';
import '../services/rate_and_review_service.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  RateAndReviewService rateAndReviewService;

  @override
  void initState() {
    super.initState();

    rateAndReviewService = Provider.of<RateAndReviewService>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!rateAndReviewService.showRateAndReviewDialog) {
        return;
      }

      // MK Wait for all of the animations to finish before showing the dialog
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      await _showRateAndReviewDialog(context);
    });
  }

  Future<void> _showRateAndReviewDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.RateAndReview),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'We apologise that we\'re interupting you but we would really appreciate your support.\n'),
              const Text(
                  'If you\'re enjoying ${Strings.AppTitle} app, would you mind taking a moment to rate it? It shouldn\'t take more than a minute.\n'),
              const Text('Thank you.'),
            ],
          ),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            FlatButton(
              child: Text('${Strings.AskMeLater}'),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.askMeLater();
              },
            ),
            FlatButton(
              child: Text('${Strings.DontAskAgain}'),
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.dontAskAgain();
              },
            ),
            FlatButton(
              child: Text('${Strings.Rate}'),
              color: AppTheme.primaryColorLight,
              onPressed: () async {
                Navigator.of(context).pop();

                await rateAndReviewService.requestReview();
              },
            ),
          ],
        );
      },
    );
  }
}
