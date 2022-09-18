// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<String?>? _$userNameComputed;

  @override
  String? get userName => (_$userNameComputed ??=
          Computed<String?>(() => super.userName, name: '_UserStore.userName'))
      .value;
  Computed<bool>? _$hasUserComputed;

  @override
  bool get hasUser => (_$hasUserComputed ??=
          Computed<bool>(() => super.hasUser, name: '_UserStore.hasUser'))
      .value;

  late final _$userAtom = Atom(name: '_UserStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$futureLoadUserAtom =
      Atom(name: '_UserStore.futureLoadUser', context: context);

  @override
  ObservableFuture<void>? get futureLoadUser {
    _$futureLoadUserAtom.reportRead();
    return super.futureLoadUser;
  }

  @override
  set futureLoadUser(ObservableFuture<void>? value) {
    _$futureLoadUserAtom.reportWrite(value, super.futureLoadUser, () {
      super.futureLoadUser = value;
    });
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  ObservableFuture<void> loadUser() {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.loadUser');
    try {
      return super.loadUser();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
futureLoadUser: ${futureLoadUser},
userName: ${userName},
hasUser: ${hasUser}
    ''';
  }
}
