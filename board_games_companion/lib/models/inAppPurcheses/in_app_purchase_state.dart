import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'in_app_purchase_state.freezed.dart';

@freezed
class InAppPurchasesState with _$InAppPurchasesState {
  const factory InAppPurchasesState.loadedProducts(List<ProductDetails> productDetails) =
      _loadedProducts;
  // The store cannot be reached or accessed.
  const factory InAppPurchasesState.unavailable() = _unavailable;
  // IAP product(s) not found.
  const factory InAppPurchasesState.error() = _error;
}
