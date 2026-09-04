import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';

import 'preferences_service.dart';

@singleton
class RateAndReviewService {
  RateAndReviewService(this._preferencesService, this._inAppReview);

  final PreferencesService _preferencesService;
  final InAppReview _inAppReview;

  static const Duration _requiredAppUsedForDuration = Duration(days: 14);
  static const Duration _requiredAppLaunchedForDuration = Duration(seconds: 30);
  static const int _requiredNumberOfSignificantActions = 300;

  // MK Both Apple and Google cap how often a review prompt is shown (Apple: at
  // most 3 per app, per device, per 365-day period). We mirror that by only
  // attempting a silent review at most 3 times a year, spacing attempts out
  // evenly so we never waste one of the OS quota slots on a request that would
  // be dropped anyway.
  static const Duration _minDurationBetweenReviewRequests = Duration(days: 365 ~/ 3);

  bool shouldRequestReview = false;

  Future<void> increaseNumberOfSignificantActions() async {
    int numberOfSignificantActions = _preferencesService.getNumberOfSignificantActions();
    if (numberOfSignificantActions < _requiredNumberOfSignificantActions) {
      await _preferencesService.setNumberOfSignificantActions(
        numberOfSignificantActions += 1,
      );
    }

    await _updateShouldRequestReviewFlag();
  }

  /// Silently asks the platform to show its native in-app review prompt.
  ///
  /// Triggered at a natural checkpoint (never from a button), as both Apple and
  /// Google require. The OS decides whether the prompt is actually shown, so
  /// there is no user-facing dialog and no way to know if it appeared. For an
  /// explicit "rate us" action, deep-link to the store listing instead.
  Future<void> requestReview() async {
    shouldRequestReview = false;

    if (!await _inAppReview.isAvailable()) {
      return;
    }

    await _inAppReview.requestReview();
    await _preferencesService.setLastReviewRequestDate(DateTime.now().toUtc());
  }

  Future<void> _updateShouldRequestReviewFlag() async {
    try {
      final DateTime nowUtc = DateTime.now().toUtc();
      final DateTime? firstTimeLaunchDate = _preferencesService.getFirstTimeLaunchDate();
      final DateTime? appLaunchDate = _preferencesService.getAppLaunchDate();
      if (firstTimeLaunchDate == null || appLaunchDate == null) {
        return;
      }

      final DateTime? lastReviewRequestDate = _preferencesService.getLastReviewRequestDate();
      final int numberOfSignificantActions = _preferencesService.getNumberOfSignificantActions();

      shouldRequestReview =
          firstTimeLaunchDate.add(_requiredAppUsedForDuration).isBefore(nowUtc) &&
              appLaunchDate.add(_requiredAppLaunchedForDuration).isBefore(nowUtc) &&
              numberOfSignificantActions >= _requiredNumberOfSignificantActions &&
              (lastReviewRequestDate == null ||
                  lastReviewRequestDate.add(_minDurationBetweenReviewRequests).isBefore(nowUtc));
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
