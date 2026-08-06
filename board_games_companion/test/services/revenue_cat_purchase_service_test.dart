import 'package:board_games_companion/services/environment_service.dart';
import 'package:board_games_companion/services/purchase_service.dart';
import 'package:board_games_companion/services/revenue_cat_purchase_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../mocks/preference_service_mock.dart';
import '../mocks/revenue_cat_client_mock.dart';

void main() {
  const String supporterTierIdentifier = 'coffee';

  late MockRevenueCatClient mockRevenueCatClient;
  late MockPreferencesService mockPreferencesService;
  late void Function(CustomerInfo) customerInfoUpdateListener;

  late RevenueCatPurchaseService purchaseService;

  CustomerInfo customerInfo({required bool isSupporter}) {
    final Map<String, EntitlementInfo> active = isSupporter
        ? {
            supporterEntitlementId: const EntitlementInfo(
              supporterEntitlementId,
              true,
              false,
              '2026-01-01T00:00:00Z',
              '2026-01-01T00:00:00Z',
              supporterTierIdentifier,
              false,
            ),
          }
        : <String, EntitlementInfo>{};

    return CustomerInfo(
      EntitlementInfos(active, active),
      const <String, String?>{},
      const <String>[],
      const <String>[],
      const <StoreTransaction>[],
      '2026-01-01T00:00:00Z',
      'anonymous-app-user-id',
      const <String, String?>{},
      '2026-01-01T00:00:00Z',
    );
  }

  TipTier tipTier() {
    const presentedOfferingContext = PresentedOfferingContext(
      'default',
      null,
      null,
    );
    const storeProduct = StoreProduct(
      supporterTierIdentifier,
      'A coffee for the developer',
      'Coffee',
      1.99,
      r'$1.99',
      'USD',
    );
    const package = Package(
      supporterTierIdentifier,
      PackageType.custom,
      storeProduct,
      presentedOfferingContext,
    );

    return const TipTier(
      identifier: supporterTierIdentifier,
      title: 'Coffee',
      description: 'A coffee for the developer',
      priceString: r'$1.99',
      package: package,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      const Package(
        supporterTierIdentifier,
        PackageType.custom,
        StoreProduct(
          supporterTierIdentifier,
          '',
          '',
          0,
          '',
          'USD',
        ),
        PresentedOfferingContext('default', null, null),
      ),
    );
    registerFallbackValue(PurchasesConfiguration(''));
  });

  setUp(() {
    mockRevenueCatClient = MockRevenueCatClient();
    mockPreferencesService = MockPreferencesService();

    when(() => mockRevenueCatClient.configure(any())).thenAnswer((_) async {});
    when(() => mockPreferencesService.getIsSupporter()).thenReturn(false);
    when(() => mockPreferencesService.setIsSupporter(any())).thenAnswer((_) async {});
    when(() => mockRevenueCatClient.addCustomerInfoUpdateListener(any())).thenAnswer(
      (invocation) {
        customerInfoUpdateListener =
            invocation.positionalArguments.single as void Function(CustomerInfo);
      },
    );

    purchaseService = RevenueCatPurchaseService(
      mockRevenueCatClient,
      mockPreferencesService,
      EnvironmentService(),
    );
  });

  tearDown(() {
    reset(mockRevenueCatClient);
    reset(mockPreferencesService);
  });

  group('GIVEN a freshly-created purchase service', () {
    test('WHEN read before initialize THEN the supporter status is unknown', () {
      expect(purchaseService.supporterStatus, SupporterStatus.unknown);
    });
  });

  group('GIVEN the app has cached a last-known supporter status', () {
    test(
        'WHEN initialize is called and the store cannot be reached '
        'THEN the cached status is returned (offline read)', () async {
      when(() => mockPreferencesService.getIsSupporter()).thenReturn(true);
      when(() => mockRevenueCatClient.getCustomerInfo())
          .thenThrow(PlatformException(code: 'network-error'));

      await purchaseService.initialize();

      expect(purchaseService.supporterStatus, SupporterStatus.supporter);
    });

    test(
        'WHEN initialize is called and the store confirms the user is not a supporter '
        'THEN the observable status is updated and the cache is refreshed', () async {
      when(() => mockPreferencesService.getIsSupporter()).thenReturn(true);
      when(() => mockRevenueCatClient.getCustomerInfo())
          .thenAnswer((_) async => customerInfo(isSupporter: false));

      await purchaseService.initialize();

      expect(purchaseService.supporterStatus, SupporterStatus.notSupporter);
      verify(() => mockPreferencesService.setIsSupporter(false)).called(1);
    });
  });

  group('GIVEN a user purchasing a tip tier', () {
    test(
        'WHEN the purchase completes successfully '
        'THEN the supporter status becomes supporter and is cached', () async {
      when(() => mockRevenueCatClient.purchasePackage(any()))
          .thenAnswer((_) async => customerInfo(isSupporter: true));

      final PurchaseOutcome outcome = await purchaseService.purchase(tipTier());

      expect(outcome, PurchaseOutcome.completed);
      expect(purchaseService.supporterStatus, SupporterStatus.supporter);
      verify(() => mockPreferencesService.setIsSupporter(true)).called(1);
    });

    test('WHEN the user cancels the store purchase flow THEN it is reported as cancelled',
        () async {
      when(() => mockRevenueCatClient.purchasePackage(any())).thenThrow(
        PlatformException(
          code: PurchasesErrorCode.purchaseCancelledError.index.toString(),
        ),
      );

      final PurchaseOutcome outcome = await purchaseService.purchase(tipTier());

      expect(outcome, PurchaseOutcome.cancelled);
      expect(purchaseService.supporterStatus, isNot(SupporterStatus.supporter));
    });

    test(
        'WHEN the purchase requires external approval (e.g. parental approval) '
        'THEN it is reported as pending and the observable status reflects it', () async {
      when(() => mockRevenueCatClient.purchasePackage(any())).thenThrow(
        PlatformException(
          code: PurchasesErrorCode.paymentPendingError.index.toString(),
        ),
      );

      final PurchaseOutcome outcome = await purchaseService.purchase(tipTier());

      expect(outcome, PurchaseOutcome.pending);
      expect(purchaseService.supporterStatus, SupporterStatus.pending);
    });

    test(
        'WHEN a pending purchase is later approved by the store '
        'THEN the observable supporter status eventually resolves to supporter', () async {
      when(() => mockRevenueCatClient.purchasePackage(any())).thenThrow(
        PlatformException(
          code: PurchasesErrorCode.paymentPendingError.index.toString(),
        ),
      );

      await purchaseService.purchase(tipTier());
      expect(purchaseService.supporterStatus, SupporterStatus.pending);

      // The store resolves the pending purchase later and RevenueCat notifies
      // the app through the customer-info update listener.
      customerInfoUpdateListener(customerInfo(isSupporter: true));

      expect(purchaseService.supporterStatus, SupporterStatus.supporter);
      verify(() => mockPreferencesService.setIsSupporter(true)).called(1);
    });
  });

  group('GIVEN a user restoring a previous purchase', () {
    test(
        'WHEN restorePurchases finds an active supporter entitlement '
        'THEN the observable status becomes supporter and is cached', () async {
      when(() => mockRevenueCatClient.restorePurchases())
          .thenAnswer((_) async => customerInfo(isSupporter: true));

      await purchaseService.restorePurchases();

      expect(purchaseService.supporterStatus, SupporterStatus.supporter);
      verify(() => mockPreferencesService.setIsSupporter(true)).called(1);
    });

    test(
        'WHEN restorePurchases finds no active supporter entitlement '
        'THEN the observable status becomes not-a-supporter', () async {
      when(() => mockRevenueCatClient.restorePurchases())
          .thenAnswer((_) async => customerInfo(isSupporter: false));

      await purchaseService.restorePurchases();

      expect(purchaseService.supporterStatus, SupporterStatus.notSupporter);
    });
  });

  group('GIVEN the RevenueCat offerings', () {
    test("WHEN getTipTiers is called THEN it maps the current offering's packages",
        () async {
      const presentedOfferingContext = PresentedOfferingContext('default', null, null);
      const storeProduct = StoreProduct(
        supporterTierIdentifier,
        'A coffee for the developer',
        'Coffee',
        1.99,
        r'$1.99',
        'USD',
      );
      const package = Package(
        supporterTierIdentifier,
        PackageType.custom,
        storeProduct,
        presentedOfferingContext,
      );
      const offering = Offering(
        'default',
        'Tip jar',
        <String, Object>{},
        <Package>[package],
      );
      const offerings = Offerings(
        <String, Offering>{'default': offering},
        current: offering,
      );

      when(() => mockRevenueCatClient.getOfferings()).thenAnswer((_) async => offerings);

      final List<TipTier> tipTiers = await purchaseService.getTipTiers();

      expect(tipTiers, hasLength(1));
      expect(tipTiers.single.identifier, supporterTierIdentifier);
      expect(tipTiers.single.title, 'Coffee');
      expect(tipTiers.single.priceString, r'$1.99');
    });

    test('WHEN there is no current offering THEN it returns an empty list', () async {
      const offerings = Offerings(<String, Offering>{});
      when(() => mockRevenueCatClient.getOfferings()).thenAnswer((_) async => offerings);

      final List<TipTier> tipTiers = await purchaseService.getTipTiers();

      expect(tipTiers, isEmpty);
    });
  });
}
