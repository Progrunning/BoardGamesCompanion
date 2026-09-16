import 'package:injectable/injectable.dart';

import 'hive_base_service.dart';

@singleton
class PreferencesService extends BaseHiveService<dynamic, PreferencesService> {
  PreferencesService(super.hive);

  static const String _firstTimeAppLaunchDateKey = 'firstTimeLaunchDate';
  static const String _appLaunchDateKey = 'applaunchDate';
  static const String _numberOfSignificantActionsKey = 'numberOfSignificantActions';
  static const String _lastReviewRequestDateKey = 'lastReviewRequestDate';
  static const String _expansionsPanelExpandedStateKey = 'expansionsPanelExpandedState';

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

  DateTime? getLastReviewRequestDate() {
    return _getValue(
      _lastReviewRequestDateKey,
      defaultValue: null,
    );
  }

  Future<void> setLastReviewRequestDate(DateTime lastReviewRequestDate) async {
    await _setValue(_lastReviewRequestDateKey, lastReviewRequestDate);
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
