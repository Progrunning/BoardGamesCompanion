// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$backupRestoredAtom =
      Atom(name: '_AppStore.backupRestored', context: context);

  @override
  bool? get backupRestored {
    _$backupRestoredAtom.reportRead();
    return super.backupRestored;
  }

  @override
  set backupRestored(bool? value) {
    _$backupRestoredAtom.reportWrite(value, super.backupRestored, () {
      super.backupRestored = value;
    });
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setBackupRestore(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setBackupRestore');
    try {
      return super.setBackupRestore(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
backupRestored: ${backupRestored}
    ''';
  }
}
