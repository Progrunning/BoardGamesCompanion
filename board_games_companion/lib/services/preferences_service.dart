import 'package:board_games_companion/common/hive_boxes.dart';

import 'hive_base_service.dart';

class PreferencesService extends BaseHiveService<dynamic> {
  static const String _firstTimeAppLaunchDateKey = "firstTimeLaunchDate";
  static const String _appLaunchDateKey = "applaunchDate";
  static const String _remindMeLaterDateKey = "remindMeLater";
  static const String _numberOfSignificantActionsKey =
      "numberOfSignificantActions";
  static const String _rateAndReviewDialogSeenKey = "rateAndReviewDialogSeen";
  static const String _expansionsPanelExpandedStateKey =
      "expansionsPanelExpandedState";

  Future<void> initialize() async {
    await ensureBoxOpen(HiveBoxes.Preferences);
  }

  Future<void> setAppLaunchDate() async {
    final DateTime nowUtc = DateTime.now().toUtc();
    if (await _isFirstTimeAppLaunch()) {
      await _setValue(_firstTimeAppLaunchDateKey, nowUtc);
    }

    await _setValue(_appLaunchDateKey, nowUtc);
  }

  Future<void> setRemindMeLaterDate(DateTime remindMeLaterDate) async {
    await _setValue(_remindMeLaterDateKey, remindMeLaterDate);
  }

  Future<DateTime> getFirstTimeLaunchDate() async {
    return await _getValue(
      _firstTimeAppLaunchDateKey,
      defaultValue: null,
    );
  }

  Future<DateTime> getAppLaunchDate() async {
    return await _getValue(
      _appLaunchDateKey,
      defaultValue: null,
    );
  }

  Future<DateTime> getRemindMeLaterDate() async {
    return await _getValue(
      _remindMeLaterDateKey,
      defaultValue: null,
    );
  }

  Future<bool> getRateAndReviewDialogSeen() async {
    return await _getValue(
      _rateAndReviewDialogSeenKey,
      defaultValue: false,
    );
  }

  Future<void> setRateAndReviewDialogSeen() async {
    await _setValue(
      _rateAndReviewDialogSeenKey,
      true,
    );
  }

  Future<int> getNumberOfSignificantActions() async {
    return await _getValue(
      _numberOfSignificantActionsKey,
      defaultValue: 0,
    );
  }

  Future<void> setNumberOfSignificantActions(
    int numberOfSignificantActions,
  ) async {
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

  Future<bool> getExpansionsPanelExpandedState() async {
    return await _getValue(
      _expansionsPanelExpandedStateKey,
      defaultValue: false,
    );
  }

  T _getValue<T>(dynamic key, {T defaultValue}) =>
      storageBox.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => storageBox.put(key, value);

  Future<bool> _isFirstTimeAppLaunch() async {
    final DateTime firstTimeLaunchDate = await _getValue(
      _firstTimeAppLaunchDateKey,
      defaultValue: null,
    );

    return firstTimeLaunchDate == null;
  }
}
