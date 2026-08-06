// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
// `Store` is hidden because purchases_flutter also exports an unrelated
// `Store` enum (the storefront a purchase was made through), which collides
// with MobX's `Store` mixin used below and silently breaks its code
// generator when both are imported unqualified.
import 'package:purchases_flutter/purchases_flutter.dart' hide Store;

import 'environment_service.dart';
import 'preferences_service.dart';
import 'purchase_service.dart';
import 'revenue_cat_client.dart';

part 'revenue_cat_purchase_service.g.dart';

/// The RevenueCat entitlement identifier that grants Supporter status.
///
/// All three tip tiers grant this single lifetime entitlement by design —
/// the tip amount never creates classes of supporters.
const String supporterEntitlementId = 'supporter';

@LazySingleton(as: PurchaseService)
class RevenueCatPurchaseService = _RevenueCatPurchaseService
    with _$RevenueCatPurchaseService
    implements PurchaseService;

abstract class _RevenueCatPurchaseService with Store {
  _RevenueCatPurchaseService(
    this._revenueCatClient,
    this._preferencesService,
    this._environmentService,
  ) {
    _revenueCatClient.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
  }

  final RevenueCatClient _revenueCatClient;
  final PreferencesService _preferencesService;
  final EnvironmentService _environmentService;

  @observable
  SupporterStatus supporterStatus = SupporterStatus.unknown;

  Future<void> initialize() async {
    _restoreCachedStatus();

    try {
      await _configure();
      final CustomerInfo customerInfo = await _revenueCatClient.getCustomerInfo();
      _applyCustomerInfo(customerInfo);
    } catch (_) {
      // Offline or otherwise unreachable — keep the last-cached status.
    }
  }

  Future<List<TipTier>> getTipTiers() async {
    final Offerings offerings = await _revenueCatClient.getOfferings();
    final Offering? currentOffering = offerings.current;
    if (currentOffering == null) {
      return const <TipTier>[];
    }

    return currentOffering.availablePackages
        .map(
          (Package package) => TipTier(
            identifier: package.identifier,
            title: package.storeProduct.title,
            description: package.storeProduct.description,
            priceString: package.storeProduct.priceString,
            package: package,
          ),
        )
        .toList();
  }

  Future<PurchaseOutcome> purchase(TipTier tier) async {
    try {
      final CustomerInfo customerInfo =
          await _revenueCatClient.purchasePackage(tier.package);
      _applyCustomerInfo(customerInfo);
      return supporterStatus == SupporterStatus.supporter
          ? PurchaseOutcome.completed
          : PurchaseOutcome.pending;
    } on PlatformException catch (e) {
      final PurchasesErrorCode errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome.cancelled;
      }

      if (errorCode == PurchasesErrorCode.paymentPendingError) {
        _setSupporterStatus(SupporterStatus.pending);
        return PurchaseOutcome.pending;
      }

      return PurchaseOutcome.error;
    }
  }

  Future<void> restorePurchases() async {
    final CustomerInfo customerInfo = await _revenueCatClient.restorePurchases();
    _applyCustomerInfo(customerInfo);
  }

  Future<void> _configure() async {
    final String apiKey = Platform.isIOS
        ? _environmentService.revenueCatApiKeyIos
        : _environmentService.revenueCatApiKeyAndroid;

    await _revenueCatClient.configure(PurchasesConfiguration(apiKey));
  }

  void _onCustomerInfoUpdated(CustomerInfo customerInfo) {
    _applyCustomerInfo(customerInfo);
  }

  void _applyCustomerInfo(CustomerInfo customerInfo) {
    final bool isSupporter =
        customerInfo.entitlements.active.containsKey(supporterEntitlementId);

    _setSupporterStatus(
      isSupporter ? SupporterStatus.supporter : SupporterStatus.notSupporter,
    );

    unawaited(_preferencesService.setIsSupporter(isSupporter));
  }

  void _restoreCachedStatus() {
    final bool cachedIsSupporter = _preferencesService.getIsSupporter();
    supporterStatus =
        cachedIsSupporter ? SupporterStatus.supporter : SupporterStatus.notSupporter;
  }

  @action
  void _setSupporterStatus(SupporterStatus status) {
    supporterStatus = status;
  }
}
