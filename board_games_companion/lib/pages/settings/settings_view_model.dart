// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/services/file_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/backup_file.dart';

part 'settings_view_model.g.dart';

@singleton
class SettingsViewModel = _SettingsViewModel with _$SettingsViewModel;

abstract class _SettingsViewModel with Store {
  _SettingsViewModel(this._fileService);

  final FileService _fileService;

  @observable
  ObservableList<BackupFile> backupFiles = ObservableList.of([]);

  @observable
  ObservableFuture<void>? futureLoadBackups;

  @action
  void loadBackups() => futureLoadBackups = ObservableFuture(_loadBackups());

  Future<void> _loadBackups() async =>
      backupFiles = ObservableList.of(await _fileService.getBackups());

  @action
  Future<void> backupAppsData() async {
    await _fileService.backupAppsData();
    await _loadBackups();
  }
}
