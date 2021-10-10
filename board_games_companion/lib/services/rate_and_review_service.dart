import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';

import 'preferences_service.dart';

@singleton
class RateAndReviewService {
  RateAndReviewService(this._preferencesService);

  final PreferencesService _preferencesService;
  static const Duration _requiredAppUsedForDuration = Duration(days: 14);
  static const Duration _remindMeLaterDuration = Duration(days: 7);
  static const Duration _requiredAppLaunchedForDuration = Duration(seconds: 30);
  static const int _requiredNumberOfEventsLogged = 300;

  bool showRateAndReviewDialog = false;

  Future<void> increaseNumberOfSignificantActions() async {
    int numberOfLoggedEvents = _preferencesService.getNumberOfSignificantActions();
    if (numberOfLoggedEvents < _requiredNumberOfEventsLogged) {
      await _preferencesService.setNumberOfSignificantActions(
        numberOfLoggedEvents += 1,
      );
    }

    await _updateShowRateAndReviewDialogFlag();
  }

  Future<void> requestReview() async {
    showRateAndReviewDialog = false;

    if (!await InAppReview.instance.isAvailable()) {
      return;
    }

    InAppReview.instance.requestReview();
    await _preferencesService.setRateAndReviewDialogSeen();
  }

  Future<void> askMeLater() async {
    showRateAndReviewDialog = false;
    await _preferencesService
        .setRemindMeLaterDate(DateTime.now().toUtc().add(_remindMeLaterDuration));
  }

  Future<void> dontAskAgain() async {
    showRateAndReviewDialog = false;
    await _preferencesService.setRateAndReviewDialogSeen();
  }

  Future<void> _updateShowRateAndReviewDialogFlag() async {
    try {
      final bool rateAndReviewDialogSeen = _preferencesService.getRateAndReviewDialogSeen();
      if (rateAndReviewDialogSeen) {
        return;
      }

      final DateTime nowUtc = DateTime.now().toUtc();
      final DateTime? firstTimeLaunchDate = _preferencesService.getFirstTimeLaunchDate();
      final DateTime? appLaunchDate = _preferencesService.getAppLaunchDate();
      final DateTime? remindMeLaterDate = _preferencesService.getRemindMeLaterDate();
      if (firstTimeLaunchDate == null || appLaunchDate == null || remindMeLaterDate == null) {
        return;
      }

      final int numberOfSignificantActions = _preferencesService.getNumberOfSignificantActions();

      showRateAndReviewDialog =
          firstTimeLaunchDate.add(_requiredAppUsedForDuration).isBefore(nowUtc) &&
              appLaunchDate.add(_requiredAppLaunchedForDuration).isBefore(nowUtc) &&
              (remindMeLaterDate == null || remindMeLaterDate.isBefore(nowUtc)) &&
              numberOfSignificantActions >= _requiredNumberOfEventsLogged;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
