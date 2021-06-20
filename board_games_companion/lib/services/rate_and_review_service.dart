import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';

import 'preferences_service.dart';

class RateAndReviewService {
  final PreferencesService _preferencesService;
  static const Duration _requiredAppUsedForDuration = const Duration(days: 14);
  static const Duration _remindMeLaterDuration = const Duration(days: 7);
  static const Duration _requiredAppLaunchedForDuration =
      const Duration(seconds: 30);
  static const int _requiredNumberOfEventsLogged = 300;

  RateAndReviewService(this._preferencesService);

  bool showRateAndReviewDialog = false;

  Future<void> _updateShowRateAndReviewDialogFlag() async {
    try {
      bool rateAndReviewDialogSeen =
          await _preferencesService.getRateAndReviewDialogSeen();
      if (rateAndReviewDialogSeen) {
        return false;
      }

      final DateTime nowUtc = DateTime.now().toUtc();
      final DateTime firstTimeLaunchDate =
          await _preferencesService.getFirstTimeLaunchDate();
      final DateTime appLaunchDate =
          await _preferencesService.getAppLaunchDate();
      final DateTime remindMeLaterDate =
          await _preferencesService.getRemindMeLaterDate();
      if (firstTimeLaunchDate == null || appLaunchDate == null) {
        return false;
      }

      final int numberOfSignificantActions =
          await _preferencesService.getNumberOfSignificantActions();

      showRateAndReviewDialog = firstTimeLaunchDate
              .add(_requiredAppUsedForDuration)
              .isBefore(nowUtc) &&
          appLaunchDate.add(_requiredAppLaunchedForDuration).isBefore(nowUtc) &&
          (remindMeLaterDate == null || remindMeLaterDate.isBefore(nowUtc)) &&
          numberOfSignificantActions >= _requiredNumberOfEventsLogged;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> increaseNumberOfSignificantActions() async {
    if (!await InAppReview.instance.isAvailable()) {
      return;
    }

    int numberOfLoggedEvents =
        await _preferencesService.getNumberOfSignificantActions();
    if (numberOfLoggedEvents < _requiredNumberOfEventsLogged) {
      await _preferencesService.setNumberOfSignificantActions(
        numberOfLoggedEvents += 1,
      );
    }

    await _updateShowRateAndReviewDialogFlag();
  }

  Future<void> requestReview() async {
    showRateAndReviewDialog = false;

    InAppReview.instance.requestReview();
    await _preferencesService.setRateAndReviewDialogSeen();
  }

  Future<void> askMeLater() async {
    showRateAndReviewDialog = false;
    await _preferencesService.setRemindMeLaterDate(
        DateTime.now().toUtc().add(_remindMeLaterDuration));
  }

  Future<void> dontAskAgain() async {
    showRateAndReviewDialog = false;
    await _preferencesService.setRateAndReviewDialogSeen();
  }
}
