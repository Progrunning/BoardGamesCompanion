import 'package:purchases_flutter/purchases_flutter.dart';

/// Thin pass-through wrapper around the static `Purchases` API from
/// `purchases_flutter`.
///
/// The RevenueCat SDK is exposed exclusively through static members, which
/// mocktail cannot stub directly. Routing every SDK call through this
/// instance-based seam keeps [RevenueCatPurchaseService] fully testable
/// against a mocked collaborator. This wrapper itself is a deliberate
/// pass-through and is not unit tested, per the seam decision in issue #297.
abstract class RevenueCatClient {
  Future<void> configure(PurchasesConfiguration configuration);

  Future<Offerings> getOfferings();

  Future<CustomerInfo> getCustomerInfo();

  Future<CustomerInfo> purchasePackage(Package package);

  Future<CustomerInfo> restorePurchases();

  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener);
}

class RevenueCatClientImpl implements RevenueCatClient {
  @override
  Future<void> configure(PurchasesConfiguration configuration) =>
      Purchases.configure(configuration);

  @override
  Future<Offerings> getOfferings() => Purchases.getOfferings();

  @override
  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  @override
  Future<CustomerInfo> purchasePackage(Package package) async {
    final PurchaseResult result =
        await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  @override
  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();

  @override
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener) =>
      Purchases.addCustomerInfoUpdateListener(listener);
}
