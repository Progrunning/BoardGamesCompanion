import 'package:injectable/injectable.dart';

import 'hive_base_service.dart';

@singleton
class PreferencesService extends BaseHiveService<dynamic, PreferencesService> {
  PreferencesService(super.hive);

  static const String _firstTimeAppLaunchDateKey = 'firstTimeLaunchDate';
  static const String _appLaunchDateKey = 'applaunchDate';
  static const String _remindMeLaterDateKey = 'remindMeLater';
  static const String _numberOfSignificantActionsKey = 'numberOfSignificantActions';
  static const String _rateAndReviewDialogSeenKey = 'rateAndReviewDialogSeen';
  static const String _expansionsPanelExpandedStateKey = 'expansionsPanelExpandedState';
  static const String _isSupporterKey = 'isSupporter';

  static const String _supportPromptSeenKey = 'supportPromptSeen';
  static const String _supportPromptNeverAskAgainKey = 'supportPromptNeverAskAgain';
  static const String _supportPromptRemindMeLaterDateKey = 'supportPromptRemindMeLaterDate';
  static const String _numberOfSignificantActionsForSupportPromptKey =
      'numberOfSignificantActionsForSupportPrompt';
  // MK Not surfaced by RateAndReviewService itself (it only persists a single
  // "seen" flag with no timestamp), so SupportPromptService lazily stamps this
  // the first time it observes the rate-and-review prompt as resolved, and
  // measures its own precedence cooldown from that point.
  static const String _rateAndReviewResolvedAtKey = 'rateAndReviewResolvedAt';

  Future<void> initialize() async {
    await ensureBoxOpen();
  }

  Future<void> setAppLaunchDate() async {
    final nowUtc = DateTime.now().toUtc();
    if (_isFirstTimeAppLaunch()) {
      await _setValue(_firstTimeAppLaunchDateKey, nowUtc);
    }

    await _setValue(_appLaunchDateKey, nowUtc);
  }

  Future<void> setRemindMeLaterDate(DateTime remindMeLaterDate) async {
    await _setValue(_remindMeLaterDateKey, remindMeLaterDate);
  }

  DateTime? getFirstTimeLaunchDate() {
    return _getValue(
      _firstTimeAppLaunchDateKey,
      defaultValue: null,
    );
  }

  DateTime? getAppLaunchDate() {
    return _getValue(
      _appLaunchDateKey,
      defaultValue: null,
    );
  }

  DateTime? getRemindMeLaterDate() {
    return _getValue(
      _remindMeLaterDateKey,
      defaultValue: null,
    );
  }

  bool getRateAndReviewDialogSeen() {
    return _getValue(
      _rateAndReviewDialogSeenKey,
      defaultValue: false,
    )!;
  }

  Future<void> setRateAndReviewDialogSeen() async {
    await _setValue(
      _rateAndReviewDialogSeenKey,
      true,
    );
  }

  int getNumberOfSignificantActions() {
    return _getValue(
      _numberOfSignificantActionsKey,
      defaultValue: 0,
    )!;
  }

  Future<void> setNumberOfSignificantActions(int numberOfSignificantActions) async {
    await _setValue(
      _numberOfSignificantActionsKey,
      numberOfSignificantActions,
    );
  }

  Future<void> setExpansionsPanelExpandedState(bool isExpanded) async {
    await _setValue(
      _expansionsPanelExpandedStateKey,
      isExpanded,
    );
  }

  bool getExpansionsPanelExpandedState() {
    return _getValue(
      _expansionsPanelExpandedStateKey,
      defaultValue: false,
    )!;
  }

  bool getIsSupporter() {
    return _getValue(
      _isSupporterKey,
      defaultValue: false,
    )!;
  }

  Future<void> setIsSupporter(bool isSupporter) async {
    await _setValue(
      _isSupporterKey,
      isSupporter,
    );
  }

  bool getSupportPromptSeen() {
    return _getValue(
      _supportPromptSeenKey,
      defaultValue: false,
    )!;
  }

  Future<void> setSupportPromptSeen() async {
    await _setValue(
      _supportPromptSeenKey,
      true,
    );
  }

  bool getSupportPromptNeverAskAgain() {
    return _getValue(
      _supportPromptNeverAskAgainKey,
      defaultValue: false,
    )!;
  }

  Future<void> setSupportPromptNeverAskAgain() async {
    await _setValue(
      _supportPromptNeverAskAgainKey,
      true,
    );
  }

  DateTime? getSupportPromptRemindMeLaterDate() {
    return _getValue(
      _supportPromptRemindMeLaterDateKey,
      defaultValue: null,
    );
  }

  Future<void> setSupportPromptRemindMeLaterDate(DateTime remindMeLaterDate) async {
    await _setValue(
      _supportPromptRemindMeLaterDateKey,
      remindMeLaterDate,
    );
  }

  int getNumberOfSignificantActionsForSupportPrompt() {
    return _getValue(
      _numberOfSignificantActionsForSupportPromptKey,
      defaultValue: 0,
    )!;
  }

  Future<void> setNumberOfSignificantActionsForSupportPrompt(
    int numberOfSignificantActions,
  ) async {
    await _setValue(
      _numberOfSignificantActionsForSupportPromptKey,
      numberOfSignificantActions,
    );
  }

  DateTime? getRateAndReviewResolvedAt() {
    return _getValue(
      _rateAndReviewResolvedAtKey,
      defaultValue: null,
    );
  }

  Future<void> setRateAndReviewResolvedAt(DateTime rateAndReviewResolvedAt) async {
    await _setValue(
      _rateAndReviewResolvedAtKey,
      rateAndReviewResolvedAt,
    );
  }

  T? _getValue<T>(dynamic key, {T? defaultValue}) =>
      storageBox.get(key, defaultValue: defaultValue) as T?;

  Future<void> _setValue<T>(dynamic key, T value) => storageBox.put(key, value);

  bool _isFirstTimeAppLaunch() {
    final DateTime? firstTimeLaunchDate = _getValue(
      _firstTimeAppLaunchDateKey,
      defaultValue: null,
    );

    return firstTimeLaunchDate == null;
  }
}
