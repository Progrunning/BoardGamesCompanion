// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/services/board_games_filters_service.dart';
import 'package:board_games_companion/services/file_service.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/stores/app_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/backup_file.dart';
import '../../services/board_games_service.dart';
import '../../services/playthroughs_service.dart';
import '../../services/preferences_service.dart';
import '../../services/score_service.dart';
import '../../services/user_service.dart';
import 'settings_page_user_visual_states.dart';
import 'settings_page_visual_states.dart';

part 'settings_view_model.g.dart';

@singleton
class SettingsViewModel = _SettingsViewModel with _$SettingsViewModel;

abstract class _SettingsViewModel with Store {
  _SettingsViewModel(
    this._fileService,
    this._boardGamesService,
    this._boardGamesFilterService,
    this._playerService,
    this._userService,
    this._playthroughService,
    this._scoreService,
    this._preferencesService,
    this._appStore,
    this._userStore,
    this._boardGamesStore,
  );

  final FileService _fileService;
  final BoardGamesService _boardGamesService;
  final BoardGamesFiltersService _boardGamesFilterService;
  final PlayerService _playerService;
  final UserService _userService;
  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PreferencesService _preferencesService;
  final AppStore _appStore;
  final UserStore _userStore;
  final BoardGamesStore _boardGamesStore;

  @observable
  ObservableList<BackupFile> backupFiles = ObservableList.of([]);

  @observable
  SettingsPageVisualState visualState = const SettingsPageVisualState.initial();

  @computed
  SettingsPageUserVisualState get userVisualState => _userStore.hasUser
      ? const SettingsPageUserVisualState.user()
      : const SettingsPageUserVisualState.noUser();

  @computed
  String? get userName => _userStore.userName;

  @observable
  ObservableFuture<void>? futureLoadBackups;

  @computed
  bool get hasAnyBackupFiles => backupFiles.isNotEmpty;

  @action
  void loadBackups() => futureLoadBackups = ObservableFuture(_loadBackups());

  Future<void> shareBackupFile(BackupFile backupFile, {Rect? sharePositionOrigin}) async =>
      Share.shareFiles(
        [backupFile.path],
        mimeTypes: ['application/zip'],
        sharePositionOrigin: sharePositionOrigin,
      );

  @action
  Future<void> deleteBackup(BackupFile backupFile) async {
    await _fileService.deleteFileFromDocumentsDirectory(
        '${FileService.backupDirectoryName}/${backupFile.nameWithExtension}');
    backupFiles.remove(backupFile);
  }

  @action
  Future<void> removeUser() async {
    await _userStore.removeUser();
    await _boardGamesStore.removeAllBggBoardGames();
  }

  @action
  Future<void> backupAppsData() async {
    await _fileService.backupAppData();
    await _loadBackups();
  }

  @action
  Future<void> restoreAppData() async {
    try {
      _appStore.setBackupRestore(false);

      visualState = const SettingsPageVisualState.restoring();

      _boardGamesService.closeBox();
      _boardGamesFilterService.closeBox();
      _playerService.closeBox();
      _userService.closeBox();
      _playthroughService.closeBox();
      _scoreService.closeBox();
      _preferencesService.closeBox();

      // MK Restore files
      await _fileService.restoreAppData();

      await _preferencesService.initialize();
      _appStore.setBackupRestore(true);
    } on Exception {
      visualState = const SettingsPageVisualState.restoringFailure();
    }

    visualState = const SettingsPageVisualState.restoringSuccess();
  }

  Future<void> _loadBackups() async =>
      backupFiles = ObservableList.of(await _fileService.getBackups()
        ..sort((BackupFile backupFile, BackupFile otherBackupFile) =>
            otherBackupFile.changed.compareTo(backupFile.changed)));
}
