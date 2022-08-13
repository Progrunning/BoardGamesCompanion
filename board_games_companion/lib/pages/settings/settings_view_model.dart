// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/services/file_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/backup_file.dart';

part 'settings_view_model.g.dart';

@singleton
class SettingsViewModel = _SettingsViewModel with _$SettingsViewModel;

abstract class _SettingsViewModel with Store {
  _SettingsViewModel(this._fileService);

  final FileService _fileService;

  @observable
  ObservableList<BackupFile> backupFiles = ObservableList.of([]);

  @computed
  bool get hasAnyBackupFiles => backupFiles.isNotEmpty;

  @observable
  ObservableFuture<void>? futureLoadBackups;

  @action
  void loadBackups() => futureLoadBackups = ObservableFuture(_loadBackups());

  Future<void> shareBackupFile(BackupFile backupFile) async => Share.shareFiles(
        [backupFile.path],
        mimeTypes: ['application/zip'],
      );

  @action
  Future<void> deleteBackup(BackupFile backupFile) async {
    await _fileService.deleteFileFromDocumentsDirectory(
        '${FileService.backupDirectoryName}/${backupFile.nameWithExtension}');
    backupFiles.remove(backupFile);
  }

  Future<void> _loadBackups() async =>
      backupFiles = ObservableList.of(await _fileService.getBackups()
        ..sort((BackupFile backupFile, BackupFile otherBackupFile) =>
            otherBackupFile.changed.compareTo(backupFile.changed)));

  @action
  Future<void> backupAppsData() async {
    await _fileService.backupAppData();
    await _loadBackups();
  }
}
