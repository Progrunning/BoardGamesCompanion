import 'package:board_games_companion/services/rate_and_review_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics;
  final RateAndReviewService _rateAndReviewService;

  AnalyticsService(this._firebaseAnalytics, this._rateAndReviewService);

  Future<void> logEvent({
    @required String name,
    Map<String, dynamic> parameters,
  }) async {
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    await _rateAndReviewService.increaseNumberOfSignificantActions();
  }

  Future<void> setUserId(String userId) async {
    await _firebaseAnalytics.setUserId(userId);
  }
}