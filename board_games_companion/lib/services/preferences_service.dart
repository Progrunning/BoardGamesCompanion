import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import 'hive_base_service.dart';

@singleton
class PreferencesService extends BaseHiveService<dynamic> {
  static const String _firstTimeAppLaunchDateKey = 'firstTimeLaunchDate';
  static const String _appLaunchDateKey = 'applaunchDate';
  static const String _remindMeLaterDateKey = 'remindMeLater';
  static const String _numberOfSignificantActionsKey = 'numberOfSignificantActions';
  static const String _rateAndReviewDialogSeenKey = 'rateAndReviewDialogSeen';
  static const String _expansionsPanelExpandedStateKey = 'expansionsPanelExpandedState';
  static const String _migratedToMultipleCollectionsKey = 'migratedToMultipleCollections';

  Future<void> initialize() async {
    await ensureBoxOpen(HiveBoxes.Preferences);
  }

  Future<void> setAppLaunchDate() async {
    final DateTime nowUtc = DateTime.now().toUtc();
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

  bool getMigratedToMultipleCollections() {
    return _getValue(
      _migratedToMultipleCollectionsKey,
      defaultValue: false,
    )!;
  }

  Future<void> setMigratedToMultipleCollections(
      {required bool migratedToMultipleCollections}) async {
    await _setValue(
      _migratedToMultipleCollectionsKey,
      migratedToMultipleCollections,
    );
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
