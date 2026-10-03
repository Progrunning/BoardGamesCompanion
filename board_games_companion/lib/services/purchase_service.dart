import 'package:purchases_flutter/purchases_flutter.dart';

/// The user's current Supporter-entitlement status, derived from RevenueCat.
///
/// [pending] represents a purchase awaiting resolution outside of this app
/// (e.g. Ask to Buy/parental approval). It is a transient, non-persisted
/// state: once the store confirms or rejects the purchase, a
/// [CustomerInfo] update resolves it to [supporter] or [notSupporter].
enum SupporterStatus {
  unknown,
  notSupporter,
  pending,
  supporter,
}

/// The immediate outcome of calling [PurchaseService.purchase].
///
/// This is distinct from [SupporterStatus]: it reports what happened to the
/// purchase attempt itself, while [SupporterStatus] tracks the durable,
/// observable entitlement state that every consumer should read from.
enum PurchaseOutcome {
  completed,
  pending,
  cancelled,
  error,
}

/// A single one-time tip a user can purchase to become a Supporter.
///
/// Wraps a RevenueCat [Package] with the store-localized display data a tip
/// screen needs, without leaking the rest of the RevenueCat surface.
class TipTier {
  const TipTier({
    required this.identifier,
    required this.title,
    required this.description,
    required this.priceString,
    required this.package,
  });

  final String identifier;
  final String title;
  final String description;
  final String priceString;
  final Package package;
}

/// Abstracts the RevenueCat (`purchases_flutter`) SDK behind a single seam
/// so the rest of the app never depends on the SDK directly.
///
/// Every consumer of the tip-jar feature (tip screen, cosmetic gating,
/// Discord reveal) should depend on this interface rather than on
/// `purchases_flutter` or the concrete implementation.
abstract class PurchaseService {
  /// The current, observable Supporter-entitlement status. Backed by MobX
  /// on the concrete implementation so consumers can react to changes,
  /// including a purchase that was initially [SupporterStatus.pending]
  /// eventually resolving to [SupporterStatus.supporter].
  SupporterStatus get supporterStatus;

  /// Refreshes [supporterStatus] from the last-cached value immediately,
  /// then attempts to reconcile it against the store. Safe to call when
  /// offline: a failed refresh silently keeps the last-known status.
  ///
  /// Call once on app start.
  Future<void> initialize();

  /// The available tip tiers (RevenueCat's current offering), in the order
  /// returned by RevenueCat.
  Future<List<TipTier>> getTipTiers();

  /// Drives the platform's native store purchase flow for [tier].
  ///
  /// Returns the immediate [PurchaseOutcome]. A [PurchaseOutcome.pending]
  /// result means [supporterStatus] has moved to [SupporterStatus.pending]
  /// and will resolve later via a store-initiated update.
  Future<PurchaseOutcome> purchase(TipTier tier);

  /// Restores any previous purchases for the current store account and
  /// refreshes [supporterStatus] accordingly.
  Future<void> restorePurchases();
}
