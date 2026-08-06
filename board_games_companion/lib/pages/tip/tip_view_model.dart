// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../services/analytics_service.dart';
import '../../services/purchase_service.dart';
import 'tip_page_visual_state.dart';
import 'tip_purchase_visual_state.dart';

part 'tip_view_model.g.dart';

@singleton
class TipViewModel = _TipViewModel with _$TipViewModel;

abstract class _TipViewModel with Store {
  _TipViewModel(
    this._purchaseService,
    this._analyticsService,
  ) {
    _supporterStatusReactionDisposer = reaction<SupporterStatus>(
      (_) => _purchaseService.supporterStatus,
      _onSupporterStatusChanged,
    );
  }

  final PurchaseService _purchaseService;
  final AnalyticsService _analyticsService;

  late final ReactionDisposer _supporterStatusReactionDisposer;

  TipTier? _lastAttemptedTier;

  @observable
  ObservableList<TipTier>? tipTiers;

  @observable
  TipPageVisualState visualState = const TipPageVisualState.loading();

  @observable
  TipPurchaseVisualState purchaseVisualState = const TipPurchaseVisualState.idle();

  @computed
  bool get hasAnyTipTiers => tipTiers?.isNotEmpty ?? false;

  /// The current, observable Supporter status — reactively derived from
  /// [PurchaseService.supporterStatus] so the tip screen can reflect an
  /// already-tipped state, or a pending purchase resolving in the
  /// background, without any extra wiring.
  @computed
  SupporterStatus get supporterStatus => _purchaseService.supporterStatus;

  @computed
  bool get isSupporter => supporterStatus == SupporterStatus.supporter;

  /// Whether the "Join the supporters' Discord" action should be shown —
  /// gated purely on Supporter status, no verification bot or backend
  /// linkage involved.
  @computed
  bool get canJoinDiscord => isSupporter;

  void trackTipScreenViewed() {
    unawaited(_analyticsService.logEvent(name: Analytics.viewTipScreen));
  }

  @action
  Future<void> loadTipTiers() async {
    try {
      visualState = const TipPageVisualState.loading();
      tipTiers = ObservableList.of(await _purchaseService.getTipTiers());
      visualState = const TipPageVisualState.loaded();
    } catch (e, stack) {
      visualState = const TipPageVisualState.failedLoading();
      _recordError(e, stack);
    }
  }

  @action
  Future<void> purchase(TipTier tier) async {
    _lastAttemptedTier = tier;
    purchaseVisualState = const TipPurchaseVisualState.purchasing();

    unawaited(_analyticsService.logEvent(
      name: Analytics.startTipPurchase,
      parameters: <String, String?>{Analytics.tipTierIdParameter: tier.identifier},
    ));

    try {
      final PurchaseOutcome outcome = await _purchaseService.purchase(tier);
      _applyPurchaseOutcome(tier, outcome);
    } catch (e, stack) {
      purchaseVisualState = const TipPurchaseVisualState.failed();
      unawaited(_analyticsService.logEvent(
        name: Analytics.failTipPurchase,
        parameters: <String, String?>{Analytics.tipTierIdParameter: tier.identifier},
      ));
      _recordError(e, stack);
    }
  }

  /// Retries the purchase of the tier last attempted, e.g. from a retry
  /// affordance shown alongside a [TipPurchaseVisualState.failed] state.
  @action
  Future<void> retryLastPurchase() async {
    if (_lastAttemptedTier == null) {
      return;
    }

    await purchase(_lastAttemptedTier!);
  }

  @action
  void dismissPurchaseResult() {
    purchaseVisualState = const TipPurchaseVisualState.idle();
  }

  @action
  Future<void> restorePurchases() async {
    try {
      await _purchaseService.restorePurchases();
      unawaited(_analyticsService.logEvent(name: Analytics.restoreTipPurchases));
    } catch (e, stack) {
      _recordError(e, stack);
    }
  }

  @action
  void _applyPurchaseOutcome(TipTier tier, PurchaseOutcome outcome) {
    switch (outcome) {
      case PurchaseOutcome.completed:
        purchaseVisualState = const TipPurchaseVisualState.completed();
        unawaited(_analyticsService.logEvent(
          name: Analytics.completeTipPurchase,
          parameters: <String, String?>{Analytics.tipTierIdParameter: tier.identifier},
        ));
      case PurchaseOutcome.pending:
        purchaseVisualState = const TipPurchaseVisualState.pending();
      case PurchaseOutcome.cancelled:
        // Return calmly to the tip screen — no error dialog/snackbar.
        purchaseVisualState = const TipPurchaseVisualState.idle();
        unawaited(_analyticsService.logEvent(
          name: Analytics.cancelTipPurchase,
          parameters: <String, String?>{Analytics.tipTierIdParameter: tier.identifier},
        ));
      case PurchaseOutcome.error:
        purchaseVisualState = const TipPurchaseVisualState.failed();
        unawaited(_analyticsService.logEvent(
          name: Analytics.failTipPurchase,
          parameters: <String, String?>{Analytics.tipTierIdParameter: tier.identifier},
        ));
        _recordError(
          'Tip purchase failed for tier ${tier.identifier}',
          StackTrace.current,
        );
    }
  }

  /// Records an error via the app's crash-reporting path. Defensive against
  /// crash reporting itself being unavailable (e.g. Firebase not
  /// initialized, such as in unit tests) so a reporting failure never masks
  /// the real error-handling behaviour above it.
  void _recordError(Object error, StackTrace stack) {
    try {
      FirebaseCrashlytics.instance.recordError(error, stack);
    } catch (_) {
      // Crash reporting itself is unavailable — nothing more we can do.
    }
  }

  /// A [PurchaseOutcome.pending] purchase (e.g. awaiting parental approval)
  /// resolves later via a store-initiated update to [supporterStatus]. This
  /// reaction reflects that eventual resolution in [purchaseVisualState]
  /// without the page needing to poll anything.
  @action
  void _onSupporterStatusChanged(SupporterStatus status) {
    if (status == SupporterStatus.supporter &&
        purchaseVisualState == const TipPurchaseVisualState.pending()) {
      purchaseVisualState = const TipPurchaseVisualState.completed();
    }
  }

  void dispose() {
    _supporterStatusReactionDisposer();
  }
}
