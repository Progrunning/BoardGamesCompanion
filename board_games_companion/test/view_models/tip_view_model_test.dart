import 'package:board_games_companion/pages/tip/tip_page_visual_state.dart';
import 'package:board_games_companion/pages/tip/tip_purchase_visual_state.dart';
import 'package:board_games_companion/pages/tip/tip_view_model.dart';
import 'package:board_games_companion/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../mocks/analytics_service_mock.dart';
import '../mocks/purchase_service_mock.dart';

void main() {
  const String coffeeTierIdentifier = 'coffee';
  const String pizzaTierIdentifier = 'pizza';

  TipTier tipTier(String identifier, {String title = 'Coffee'}) {
    const presentedOfferingContext = PresentedOfferingContext('default', null, null);
    final storeProduct = StoreProduct(
      identifier,
      'A tip for the developer',
      title,
      1.99,
      r'$1.99',
      'USD',
    );
    final package = Package(
      identifier,
      PackageType.custom,
      storeProduct,
      presentedOfferingContext,
    );

    return TipTier(
      identifier: identifier,
      title: title,
      description: 'A tip for the developer',
      priceString: r'$1.99',
      package: package,
    );
  }

  late MockPurchaseService mockPurchaseService;
  late MockAnalyticsService mockAnalyticsService;
  late TipViewModel tipViewModel;

  setUpAll(() {
    registerFallbackValue(tipTier(coffeeTierIdentifier));
  });

  setUp(() {
    mockPurchaseService = MockPurchaseService();
    mockAnalyticsService = MockAnalyticsService();

    when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.notSupporter);
    when(() => mockAnalyticsService.logEvent(name: any(named: 'name'), parameters: any(named: 'parameters')))
        .thenAnswer((_) async {});

    tipViewModel = TipViewModel(mockPurchaseService, mockAnalyticsService);
  });

  group('GIVEN the tip screen is opened ', () {
    test(
        'WHEN the store returns tip tiers '
        'THEN the view model exposes them and moves to the loaded state ', () async {
      final tiers = [tipTier(coffeeTierIdentifier), tipTier(pizzaTierIdentifier, title: 'Pizza')];
      when(() => mockPurchaseService.getTipTiers()).thenAnswer((_) async => tiers);

      await tipViewModel.loadTipTiers();

      expect(tipViewModel.visualState, const TipPageVisualState.loaded());
      expect(tipViewModel.hasAnyTipTiers, isTrue);
      expect(tipViewModel.tipTiers!.map((tier) => tier.identifier),
          [coffeeTierIdentifier, pizzaTierIdentifier]);
    });

    test(
        'WHEN the store is unreachable '
        'THEN the view model degrades to a failed-loading state ', () async {
      when(() => mockPurchaseService.getTipTiers()).thenThrow(Exception('store unreachable'));

      await tipViewModel.loadTipTiers();

      expect(tipViewModel.visualState, const TipPageVisualState.failedLoading());
      expect(tipViewModel.hasAnyTipTiers, isFalse);
    });
  });

  group('GIVEN a user taps a tip tier ', () {
    test(
        'WHEN the purchase completes '
        'THEN the view model shows the completed/thank-you state ', () async {
      final tier = tipTier(coffeeTierIdentifier);
      when(() => mockPurchaseService.purchase(tier))
          .thenAnswer((_) async => PurchaseOutcome.completed);

      await tipViewModel.purchase(tier);

      expect(tipViewModel.purchaseVisualState, const TipPurchaseVisualState.completed());
    });

    test(
        'WHEN the purchase is pending (e.g. awaiting parental approval) '
        'THEN the view model shows the pending state ', () async {
      final tier = tipTier(coffeeTierIdentifier);
      when(() => mockPurchaseService.purchase(tier))
          .thenAnswer((_) async => PurchaseOutcome.pending);

      await tipViewModel.purchase(tier);

      expect(tipViewModel.purchaseVisualState, const TipPurchaseVisualState.pending());
    });

    test(
        'WHEN the purchase is cancelled by the user '
        'THEN the view model returns calmly to its normal (idle) state ', () async {
      final tier = tipTier(coffeeTierIdentifier);
      when(() => mockPurchaseService.purchase(tier))
          .thenAnswer((_) async => PurchaseOutcome.cancelled);

      await tipViewModel.purchase(tier);

      expect(tipViewModel.purchaseVisualState, const TipPurchaseVisualState.idle());
    });

    test(
        'WHEN the purchase errors '
        'THEN the view model shows a failed state ', () async {
      final tier = tipTier(coffeeTierIdentifier);
      when(() => mockPurchaseService.purchase(tier))
          .thenAnswer((_) async => PurchaseOutcome.error);

      await tipViewModel.purchase(tier);

      expect(tipViewModel.purchaseVisualState, const TipPurchaseVisualState.failed());
    });
  });

  group('GIVEN the user has already tipped ', () {
    test(
        'WHEN reading the supporter status '
        'THEN the view model reflects the already-tipped (supporter) state ', () async {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.supporter);

      expect(tipViewModel.isSupporter, isTrue);
    });
  });

  group("GIVEN the supporters' Discord join action ", () {
    test(
        'WHEN the user is a Supporter '
        'THEN the view model exposes it as available ', () async {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.supporter);

      expect(tipViewModel.canJoinDiscord, isTrue);
    });

    test(
        'WHEN the user is not a Supporter '
        'THEN the view model exposes it as unavailable ', () async {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.notSupporter);

      expect(tipViewModel.canJoinDiscord, isFalse);
    });

    test(
        "WHEN the user's purchase is pending "
        'THEN the view model exposes it as unavailable ', () async {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.pending);

      expect(tipViewModel.canJoinDiscord, isFalse);
    });
  });

  group('GIVEN the user wants to restore a previous purchase ', () {
    test(
        'WHEN restorePurchases is called '
        'THEN the purchase service is asked to restore purchases ', () async {
      when(() => mockPurchaseService.restorePurchases()).thenAnswer((_) async {});

      await tipViewModel.restorePurchases();

      verify(() => mockPurchaseService.restorePurchases()).called(1);
    });

    test(
        'WHEN restoring purchases fails '
        'THEN the view model does not throw and no purchase failure state is shown ', () async {
      when(() => mockPurchaseService.restorePurchases()).thenThrow(Exception('offline'));

      await tipViewModel.restorePurchases();

      expect(tipViewModel.purchaseVisualState, const TipPurchaseVisualState.idle());
    });
  });
}
