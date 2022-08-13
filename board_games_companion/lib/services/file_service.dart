import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/backup_file.dart';

@singleton
class FileService {
  Future<File?> saveToDocumentsDirectory(
    String fileName,
    XFile pickedFile, {
    bool overrideExistingFile = false,
  }) async {
    try {
      final fileContent = await pickedFile.readAsBytes();
      final avatarImageToSave = await _retrieveDocumentsFile(fileName);
      if (!overrideExistingFile && avatarImageToSave.existsSync()) {
        throw FileSystemException("Can't save file $fileName because it already exists");
      }

      final savedAvatarImage = await avatarImageToSave.writeAsBytes(fileContent);

      return savedAvatarImage;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<bool> deleteFileFromDocumentsDirectory(String fileName) async {
    if (fileName.isEmpty) {
      return false;
    }

    try {
      final fileToDelete = await _retrieveDocumentsFile(fileName);
      await fileToDelete.delete();

      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> fileExists(String fileUri) async {
    try {
      if (fileUri.isEmpty) {
        throw ArgumentError();
      }

      final existingFile = File(fileUri);
      return existingFile.existsSync();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<String> createDocumentsFilePath(String fileName) async {
    final documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
    return '${documentsDirectory.path}/$fileName';
  }

  Future<UnmodifiableListView<BackupFile>> getBackups() async {
    final appBackupsDirectory = await _getBackupDirectory();
    final backups = <BackupFile>[];
    await for (final FileSystemEntity fileSystemEntity in appBackupsDirectory.list()) {
      final fileStats = await fileSystemEntity.stat();
      backups.add(BackupFile(
        name: basename(fileSystemEntity.path),
        size: fileStats.size,
        changed: fileStats.changed,
      ));
    }

    return UnmodifiableListView(backups);
  }

  // ! MK Ensure the backup directory is not backed up
  Future<void> backupAppsData() async {
    final appBackupsDirectory = await _getBackupDirectory();

    final zipEncored = ZipFileEncoder();
    zipEncored.zipDirectory(
      appBackupsDirectory,
      filename: '${appBackupsDirectory.path}/BGC Backup ${DateTime.now().toIso8601String()}.zip',
    );
  }

  Future<File> _retrieveDocumentsFile(String fileName) async {
    final documentsFilePath = await createDocumentsFilePath(fileName);
    return File(documentsFilePath);
  }

  Future<Directory> _getBackupDirectory() async {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    final appBackupDirectory = Directory('${appDirectory.path}/backups');
    return appBackupDirectory.create();
  }
}
