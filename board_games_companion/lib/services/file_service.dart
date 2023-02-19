import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:basics/basics.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/backup_file.dart';

@singleton
class FileService {
  static const String backupDirectoryName = 'backups';
  static const Set<String> backupFileExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.tif',
    '.tiff',
    '.hive',
  };
  static const Set<String> ignoredBackupDirectoryNames = {'flutter_assets', 'backups'};
  static const String backupFileExtension = 'zip';

  static DateFormat backupDateFormat = DateFormat(Constants.appDataBackupDateFormat);

  Future<File?> saveToDocumentsDirectory(
    String fileName,
    XFile file, {
    bool overrideExistingFile = false,
    String? filePath,
  }) async {
    try {
      final fileContent = await file.readAsBytes();
      final fileToSave = await _retrieveDocumentsFile(fileName, filePath: filePath);

      if (!overrideExistingFile && fileToSave.existsSync()) {
        throw FileSystemException("Can't save file $fileName because it already exists");
      }

      await fileToSave.create(recursive: true);
      final savedFile = await fileToSave.writeAsBytes(fileContent, mode: FileMode.write);
      return savedFile;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<bool> deleteFileFromDocumentsDirectory(String fileName, {String? filePath}) async {
    if (fileName.isEmpty) {
      return false;
    }

    try {
      final fileToDelete = await _retrieveDocumentsFile(fileName, filePath: filePath);
      await fileToDelete.delete();

      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deleteFile(String filePath) async {
    if (filePath.isNullOrBlank) {
      return false;
    }

    try {
      final fileToDelete = File.fromUri(Uri.file(filePath));
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

  Future<String> createDocumentsFilePath(String fileName, {String? filePath}) async {
    final documentsDirectory = await path_provider.getApplicationDocumentsDirectory();

    if (filePath.isNotNullOrBlank) {
      return '${documentsDirectory.path}/$filePath/$fileName';
    }

    return '${documentsDirectory.path}/$fileName';
  }

  Future<List<BackupFile>> getBackups() async {
    final appBackupsDirectory = await _getBackupDirectory();
    final backups = <BackupFile>[];
    await for (final FileSystemEntity fileSystemEntity in appBackupsDirectory.list()) {
      final fileStats = await fileSystemEntity.stat();
      backups.add(BackupFile(
        path: fileSystemEntity.path,
        size: fileStats.size,
        changed: fileStats.changed,
      ));
    }

    return backups;
  }

  Future<void> backupAppData() async {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    final appBackupsDirectory = await _getBackupDirectory();

    return compute(archiveAppData, _ArchiveAppDataModel(appDirectory, appBackupsDirectory));
  }

  // MK This method is completely redundant from the "clean" code point of view but because dart is retarted when it comes to Isolates,
  //    there was a need for a "top" level method that has a parameter - so here you go dart lords...you won
  // ignore: library_private_types_in_public_api
  Future<void> archiveAppData(_ArchiveAppDataModel archiveAppDataModel) async {
    final zipEncoder = ZipFileEncoder();
    zipEncoder.create(
        '${archiveAppDataModel.appBackupsDirectory.path}/BGC Backup ${backupDateFormat.format(DateTime.now())}.zip');

    Future<void> addDirectoryFilesToArchive(Directory directory) async {
      await for (final FileSystemEntity fileSystemEntity in directory.list()) {
        if (FileSystemEntity.isDirectorySync(fileSystemEntity.path)) {
          final directoryName = basename(fileSystemEntity.path);
          if (ignoredBackupDirectoryNames.contains(directoryName)) {
            continue;
          }

          await addDirectoryFilesToArchive(Directory.fromUri(fileSystemEntity.uri));
        }

        if (FileSystemEntity.isFileSync(fileSystemEntity.path)) {
          final fileExtension = extension(fileSystemEntity.path);
          if (!backupFileExtensions.contains(fileExtension)) {
            continue;
          }

          // Stripping away the documents path to get file name and its directory
          final fileName =
              fileSystemEntity.path.replaceFirst('${archiveAppDataModel.appDirectory.path}/', '');
          final fileStats = await fileSystemEntity.stat();
          final fileStream = InputFileStream(fileSystemEntity.path);
          final archiveFile = ArchiveFile.stream(fileName, fileStats.size, fileStream);
          archiveFile.mode = fileStats.mode;
          archiveFile.lastModTime = fileStats.modified.millisecondsSinceEpoch ~/ 1000;

          zipEncoder.addArchiveFile(archiveFile);
          await fileStream.close();
        }
      }
    }

    await addDirectoryFilesToArchive(archiveAppDataModel.appDirectory);

    zipEncoder.close();
  }

  Future<bool> restoreAppData() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [backupFileExtension],
    );

    if (result == null) {
      // User canceled the picker
      return true;
    }

    final documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
    await extractFileToDisk(result.files.single.path!, documentsDirectory.path, asyncWrite: true);

    return false;
  }

  Future<File> _retrieveDocumentsFile(String fileName, {String? filePath}) async {
    final documentsFilePath = await createDocumentsFilePath(fileName, filePath: filePath);
    return File(documentsFilePath);
  }

  Future<Directory> _getBackupDirectory() async {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    final appBackupDirectory = Directory('${appDirectory.path}/$backupDirectoryName');
    return appBackupDirectory.create();
  }
}

class _ArchiveAppDataModel {
  _ArchiveAppDataModel(this.appDirectory, this.appBackupsDirectory);

  Directory appDirectory;
  Directory appBackupsDirectory;
}
