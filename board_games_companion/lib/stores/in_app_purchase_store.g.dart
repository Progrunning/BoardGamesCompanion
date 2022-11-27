// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_purchase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InAppPurchaseStore on _InAppPurchaseStore, Store {
  late final _$purchasProductsAtom =
      Atom(name: '_InAppPurchaseStore.purchasProducts', context: context);

  @override
  ObservableList<PurchaseDetails> get purchasProducts {
    _$purchasProductsAtom.reportRead();
    return super.purchasProducts;
  }

  @override
  set purchasProducts(ObservableList<PurchaseDetails> value) {
    _$purchasProductsAtom.reportWrite(value, super.purchasProducts, () {
      super.purchasProducts = value;
    });
  }

  late final _$stateAtom =
      Atom(name: '_InAppPurchaseStore.state', context: context);

  @override
  InAppPurchasesState? get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(InAppPurchasesState? value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$futureLoadInAppPurchasesAtom = Atom(
      name: '_InAppPurchaseStore.futureLoadInAppPurchases', context: context);

  @override
  ObservableFuture<void>? get futureLoadInAppPurchases {
    _$futureLoadInAppPurchasesAtom.reportRead();
    return super.futureLoadInAppPurchases;
  }

  @override
  set futureLoadInAppPurchases(ObservableFuture<void>? value) {
    _$futureLoadInAppPurchasesAtom
        .reportWrite(value, super.futureLoadInAppPurchases, () {
      super.futureLoadInAppPurchases = value;
    });
  }

  late final _$_InAppPurchaseStoreActionController =
      ActionController(name: '_InAppPurchaseStore', context: context);

  @override
  void loadInAppPurchases() {
    final _$actionInfo = _$_InAppPurchaseStoreActionController.startAction(
        name: '_InAppPurchaseStore.loadInAppPurchases');
    try {
      return super.loadInAppPurchases();
    } finally {
      _$_InAppPurchaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
purchasProducts: ${purchasProducts},
state: ${state},
futureLoadInAppPurchases: ${futureLoadInAppPurchases}
    ''';
  }
}
