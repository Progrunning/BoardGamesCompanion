import 'package:fimber/fimber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import 'rate_and_review_service.dart';

@singleton
class AnalyticsService {
  AnalyticsService(this._firebaseAnalytics, this._rateAndReviewService);

  final FirebaseAnalytics _firebaseAnalytics;
  final RateAndReviewService _rateAndReviewService;

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    Fimber.i('Captured an $name event with $parameters');
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    await _rateAndReviewService.increaseNumberOfSignificantActions();
  }

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    await _firebaseAnalytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClass,
    );
    await _rateAndReviewService.increaseNumberOfSignificantActions();
  }
}
