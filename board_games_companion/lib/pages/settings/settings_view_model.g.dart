// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsViewModel on _SettingsViewModel, Store {
  Computed<SettingsPageUserVisualState>? _$userVisualStateComputed;

  @override
  SettingsPageUserVisualState get userVisualState =>
      (_$userVisualStateComputed ??= Computed<SettingsPageUserVisualState>(
              () => super.userVisualState,
              name: '_SettingsViewModel.userVisualState'))
          .value;
  Computed<String?>? _$userNameComputed;

  @override
  String? get userName =>
      (_$userNameComputed ??= Computed<String?>(() => super.userName,
              name: '_SettingsViewModel.userName'))
          .value;
  Computed<bool>? _$hasAnyBackupFilesComputed;

  @override
  bool get hasAnyBackupFiles => (_$hasAnyBackupFilesComputed ??= Computed<bool>(
          () => super.hasAnyBackupFiles,
          name: '_SettingsViewModel.hasAnyBackupFiles'))
      .value;

  late final _$backupFilesAtom =
      Atom(name: '_SettingsViewModel.backupFiles', context: context);

  @override
  ObservableList<BackupFile> get backupFiles {
    _$backupFilesAtom.reportRead();
    return super.backupFiles;
  }

  @override
  set backupFiles(ObservableList<BackupFile> value) {
    _$backupFilesAtom.reportWrite(value, super.backupFiles, () {
      super.backupFiles = value;
    });
  }

  late final _$visualStateAtom =
      Atom(name: '_SettingsViewModel.visualState', context: context);

  @override
  SettingsPageVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(SettingsPageVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$futureLoadBackupsAtom =
      Atom(name: '_SettingsViewModel.futureLoadBackups', context: context);

  @override
  ObservableFuture<void>? get futureLoadBackups {
    _$futureLoadBackupsAtom.reportRead();
    return super.futureLoadBackups;
  }

  @override
  set futureLoadBackups(ObservableFuture<void>? value) {
    _$futureLoadBackupsAtom.reportWrite(value, super.futureLoadBackups, () {
      super.futureLoadBackups = value;
    });
  }

  late final _$deleteBackupAsyncAction =
      AsyncAction('_SettingsViewModel.deleteBackup', context: context);

  @override
  Future<void> deleteBackup(BackupFile backupFile) {
    return _$deleteBackupAsyncAction.run(() => super.deleteBackup(backupFile));
  }

  late final _$removeUserAsyncAction =
      AsyncAction('_SettingsViewModel.removeUser', context: context);

  @override
  Future<void> removeUser() {
    return _$removeUserAsyncAction.run(() => super.removeUser());
  }

  late final _$backupAppsDataAsyncAction =
      AsyncAction('_SettingsViewModel.backupAppsData', context: context);

  @override
  Future<void> backupAppsData() {
    return _$backupAppsDataAsyncAction.run(() => super.backupAppsData());
  }

  late final _$restoreAppDataAsyncAction =
      AsyncAction('_SettingsViewModel.restoreAppData', context: context);

  @override
  Future<void> restoreAppData() {
    return _$restoreAppDataAsyncAction.run(() => super.restoreAppData());
  }

  late final _$_SettingsViewModelActionController =
      ActionController(name: '_SettingsViewModel', context: context);

  @override
  void loadBackups() {
    final _$actionInfo = _$_SettingsViewModelActionController.startAction(
        name: '_SettingsViewModel.loadBackups');
    try {
      return super.loadBackups();
    } finally {
      _$_SettingsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
backupFiles: ${backupFiles},
visualState: ${visualState},
futureLoadBackups: ${futureLoadBackups},
userVisualState: ${userVisualState},
userName: ${userName},
hasAnyBackupFiles: ${hasAnyBackupFiles}
    ''';
  }
}
