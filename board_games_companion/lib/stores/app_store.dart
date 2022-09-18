// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

@singleton
class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool? backupRestored;

  @action
  void setBackupRestore(bool value) => backupRestored = value;
}
