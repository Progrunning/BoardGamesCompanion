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
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    await _rateAndReviewService.increaseNumberOfSignificantActions();
  }

  Future<void> setUserId(String userId) async {
    await _firebaseAnalytics.setUserId(userId);
  }
}
