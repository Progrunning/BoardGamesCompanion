import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = FlutterSecureStorage();

  Future<bool> setSecurly(String key, String value) async {
    try {
      await _secureStorage.write(
        key: key,
        value: value,
      );

      return true;
    } on Exception catch (ex, stack) {
      Crashlytics.instance.recordError(ex, stack);
    }

    return false;
  }

  Future<String> getSecurly(String key) async {
    try {
      return await _secureStorage.read(
        key: key,
      );
    } on Exception catch (ex, stack) {
      Crashlytics.instance.recordError(ex, stack);
    }

    return null;
  }

  Future<bool> removeKey(String key) async {
    try {
      await _secureStorage.delete(
        key: key,
      );

      return true;
    } on Exception catch (ex, stack) {
      Crashlytics.instance.recordError(ex, stack);
    }

    return false;
  }
}
