import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';

import 'preferences_service.dart';

class RateAndReviewService {
  final PreferencesService _preferencesService;
  static const Duration _requiredAppUsedForDuration = const Duration(days: 14);
  static const Duration _requiredAppLaunchedForDuration =
      const Duration(seconds: 30);
  static const int _requiredNumberOfEventsLogged = 300;

  RateAndReviewService(this._preferencesService);

  Future<bool> _showRateAndReviewDialog() async {
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
      if (firstTimeLaunchDate == null || appLaunchDate == null) {
        return false;
      }

      final int numberOfSignificantActions =
          await _preferencesService.getNumberOfSignificantActions();

      final bool showRateAndReviewDialog = firstTimeLaunchDate
              .add(_requiredAppUsedForDuration)
              .isBefore(nowUtc) &&
          appLaunchDate.add(_requiredAppLaunchedForDuration).isBefore(nowUtc) &&
          numberOfSignificantActions >= _requiredNumberOfEventsLogged;
      if (showRateAndReviewDialog) {
        InAppReview.instance.requestReview();
        await _preferencesService.setRateAndReviewDialogSeen();
      }

      return showRateAndReviewDialog;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
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

    await _showRateAndReviewDialog();
  }
}
