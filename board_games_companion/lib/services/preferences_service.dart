import 'package:board_games_companion/common/hive_boxes.dart';

import 'hive_base_service.dart';

class PreferencesService extends BaseHiveService<dynamic> {
  static const String _firstTimeLaunchDateKey = "firstTimeLaunchDate";
  static const String _numberOfSignificantActionsKey =
      "numberOfSignificantActions";
  static const String _rateAndReviewDialogSeenKey = "rateAndReviewDialogSeen";

  Future<void> initialize() async {
    await ensureBoxOpen(HiveBoxes.Preferences);
  }

  Future<void> setFirstTimeLaunchDate() async {
    if (await _isFirstTimeAppLaunch()) {
      await _setValue(_firstTimeLaunchDateKey, DateTime.now().toUtc());
    }
  }

  Future<DateTime> getFirstTimeLaunchDate() async {
    return await _getValue(
      _firstTimeLaunchDateKey,
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

  T _getValue<T>(dynamic key, {T defaultValue}) =>
      storageBox.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => storageBox.put(key, value);

  Future<bool> _isFirstTimeAppLaunch() async {
    final DateTime firstTimeLaunchDate = await _getValue(
      _firstTimeLaunchDateKey,
      defaultValue: null,
    );

    return firstTimeLaunchDate == null;
  }
}
