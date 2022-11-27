// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/inAppPurcheses/in_app_purchase_state.dart';

part 'in_app_purchase_store.g.dart';

@singleton
class InAppPurchaseStore = _InAppPurchaseStore with _$InAppPurchaseStore;

abstract class _InAppPurchaseStore with Store {
  _InAppPurchaseStore() {
    InAppPurchase.instance.purchaseStream.listen(
      (purchaseDetailsList) {
        purchasProducts = purchaseDetailsList.asObservable();
      },
      onDone: () {},
      onError: (Object error) {
        // handle error here.
      },
    );
  }

  @observable
  ObservableList<PurchaseDetails> purchasProducts = ObservableList.of([]);

  @observable
  InAppPurchasesState? state;

  @observable
  ObservableFuture<void>? futureLoadInAppPurchases;

  @action
  void loadInAppPurchases() =>
      futureLoadInAppPurchases = ObservableFuture<void>(_loadInAppPurchases());

  Future<void> _loadInAppPurchases() async {
    final isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      state = const InAppPurchasesState.unavailable();
    }

    const iapProductIds = <String>{'product1', 'product2'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(iapProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      state = const InAppPurchasesState.error();
      return;
    }

    state = InAppPurchasesState.loadedProducts(response.productDetails);
  }
}
