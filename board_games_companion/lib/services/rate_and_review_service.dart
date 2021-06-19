import 'package:board_games_companion/services/preferences_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';

class RateAndReviewService {
  final PreferencesService _preferencesService;
  static const Duration _requiredDurationTheAppUsedFor =
      const Duration(days: 14);
  static const int _requiredNumberOfEventsLogged = 50;

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
      if (firstTimeLaunchDate == null) {
        return false;
      }

      final int numberOfSignificantActions =
          await _preferencesService.getNumberOfSignificantActions();

      // TODO MK Change the || to && condition
      final bool showRateAndReviewDialog = firstTimeLaunchDate
              .add(_requiredDurationTheAppUsedFor)
              .isAfter(nowUtc) ||
          numberOfSignificantActions >=
              _requiredNumberOfEventsLogged;
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
    // if (!await InAppReview.instance.isAvailable()) {
    //   return;
    // }

    int numberOfSignificantActions =
        await _preferencesService.getNumberOfSignificantActions();

    await _preferencesService.setNumberOfSignificantActions(
      numberOfSignificantActions += 1,
    );

    await _showRateAndReviewDialog();
  }
}
