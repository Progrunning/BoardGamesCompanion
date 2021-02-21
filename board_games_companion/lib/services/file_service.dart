import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<File> saveToDocumentsDirectory(String fileName, PickedFile pickedFile,
      {bool overrideExistingFile = false}) async {
    try {
      final fileContent = await pickedFile.readAsBytes();
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final avatarImageToSave = File('${documentsDirectory.path}/$fileName');
      if (!overrideExistingFile && await avatarImageToSave.exists()) {
        throw new FileSystemException(
            'Can\'t save file $fileName because it already exists');
      }

      final savedAvatarImage =
          await avatarImageToSave.writeAsBytes(fileContent);

      return savedAvatarImage;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return null;
  }

  Future<bool> deleteFile(String fileUri) async {
    if (fileUri?.isEmpty ?? true) {
      return false;
    }

    try {
      final fileToDelete = File(fileUri);
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
        throw new ArgumentError();
      }

      final existingFile = File(fileUri);
      return await existingFile.exists();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
