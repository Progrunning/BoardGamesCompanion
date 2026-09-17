import 'package:fimber/fimber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import 'engagement_prompts_service.dart';

@singleton
class AnalyticsService {
  AnalyticsService(
    this._firebaseAnalytics,
    this._engagementPromptsService,
  );

  final FirebaseAnalytics _firebaseAnalytics;
  final EngagementPromptsService _engagementPromptsService;

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    Fimber.i('Captured an $name event with $parameters');
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    await _engagementPromptsService.increaseNumberOfSignificantActions();
  }

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    await _firebaseAnalytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
    await _engagementPromptsService.increaseNumberOfSignificantActions();
  }
}
