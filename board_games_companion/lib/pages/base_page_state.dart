import 'package:flutter/material.dart';

import '../injectable.dart';
import '../services/rate_and_review_service.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  late RateAndReviewService rateAndReviewService;

  @override
  void initState() {
    super.initState();

    rateAndReviewService = getIt<RateAndReviewService>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!rateAndReviewService.shouldRequestReview) {
        return;
      }

      // MK Let the launch animations settle before asking the OS to surface its
      // native review prompt.
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      await rateAndReviewService.requestReview();
    });
  }
}
