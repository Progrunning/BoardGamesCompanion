import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

import 'engagement_prompt_session_guard.dart';
import 'preferences_service.dart';
import 'rate_and_review_service.dart';

@singleton
class SupportPromptService {
  SupportPromptService(this._preferencesService, this._rateAndReviewService);

  final PreferencesService _preferencesService;
  final RateAndReviewService _rateAndReviewService;

  static const Duration _requiredAppUsedForDuration = Duration(days: 21);
  static const Duration _remindMeLaterDuration = Duration(days: 10);
  // MK Cooldown applied on top of the rate-and-review prompt being resolved,
  // so the two asks don't land back-to-back even across sessions.
  static const Duration _requiredRateAndReviewResolvedForDuration = Duration(days: 3);
  static const int _requiredNumberOfSignificantActions = 150;

  bool showSupportPromptDialog = false;

  Future<void> increaseNumberOfSignificantActions() async {
    int numberOfSignificantActions =
        _preferencesService.getNumberOfSignificantActionsForSupportPrompt();
    if (numberOfSignificantActions < _requiredNumberOfSignificantActions) {
      await _preferencesService.setNumberOfSignificantActionsForSupportPrompt(
        numberOfSignificantActions += 1,
      );
    }

    await _updateShowSupportPromptDialogFlag();
  }

  /// Called once the prompt has actually been displayed to the user - marks
  /// it as seen (for analytics/state tracking) and claims this session's
  /// single engagement-prompt slot.
  Future<void> promptShown() async {
    EngagementPromptSessionGuard.promptShownThisSession = true;
    await _preferencesService.setSupportPromptSeen();
  }

  Future<void> tip() async {
    showSupportPromptDialog = false;
    // MK Tipping resolves the ask - don't keep nagging a user who already
    // chose to support the app through this prompt.
    await _preferencesService.setSupportPromptNeverAskAgain();
  }

  Future<void> askMeLater() async {
    showSupportPromptDialog = false;
    await _preferencesService
        .setSupportPromptRemindMeLaterDate(DateTime.now().toUtc().add(_remindMeLaterDuration));
  }

  Future<void> dontAskAgain() async {
    showSupportPromptDialog = false;
    await _preferencesService.setSupportPromptNeverAskAgain();
  }

  Future<void> _updateShowSupportPromptDialogFlag() async {
    try {
      if (EngagementPromptSessionGuard.promptShownThisSession) {
        return;
      }

      final bool supportPromptNeverAskAgain = _preferencesService.getSupportPromptNeverAskAgain();
      if (supportPromptNeverAskAgain) {
        return;
      }

      // MK Eligible only once the rate-and-review prompt is resolved - that
      // service persists a single flag covering both "shown" and "dismissed
      // forever", so that's precisely what "resolved" means here.
      final bool rateAndReviewResolved = _preferencesService.getRateAndReviewDialogSeen();
      if (!rateAndReviewResolved) {
        return;
      }

      final DateTime nowUtc = DateTime.now().toUtc();

      DateTime? rateAndReviewResolvedAt = _preferencesService.getRateAndReviewResolvedAt();
      if (rateAndReviewResolvedAt == null) {
        rateAndReviewResolvedAt = nowUtc;
        await _preferencesService.setRateAndReviewResolvedAt(rateAndReviewResolvedAt);
      }

      final DateTime? firstTimeLaunchDate = _preferencesService.getFirstTimeLaunchDate();
      final DateTime? remindMeLaterDate = _preferencesService.getSupportPromptRemindMeLaterDate();
      if (firstTimeLaunchDate == null) {
        return;
      }

      final int numberOfSignificantActions =
          _preferencesService.getNumberOfSignificantActionsForSupportPrompt();

      showSupportPromptDialog =
          !_rateAndReviewService.showRateAndReviewDialog &&
              firstTimeLaunchDate.add(_requiredAppUsedForDuration).isBefore(nowUtc) &&
              rateAndReviewResolvedAt
                  .add(_requiredRateAndReviewResolvedForDuration)
                  .isBefore(nowUtc) &&
              (remindMeLaterDate == null || remindMeLaterDate.isBefore(nowUtc)) &&
              numberOfSignificantActions >= _requiredNumberOfSignificantActions;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
