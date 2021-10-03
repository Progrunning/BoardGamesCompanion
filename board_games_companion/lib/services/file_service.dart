import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

@singleton
class FileService {
  Future<File?> saveToDocumentsDirectory(String fileName, PickedFile pickedFile,
      {bool overrideExistingFile = false}) async {
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
      if (fileUri?.isEmpty ?? true) {
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

  Future<File> _retrieveDocumentsFile(String fileName) async {
    final documentsFilePath = await createDocumentsFilePath(fileName);
    return File(documentsFilePath);
  }
}
