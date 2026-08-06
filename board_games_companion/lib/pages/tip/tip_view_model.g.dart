// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TipViewModel on _TipViewModel, Store {
  Computed<bool>? _$hasAnyTipTiersComputed;

  @override
  bool get hasAnyTipTiers =>
      (_$hasAnyTipTiersComputed ??= Computed<bool>(() => super.hasAnyTipTiers,
              name: '_TipViewModel.hasAnyTipTiers'))
          .value;
  Computed<SupporterStatus>? _$supporterStatusComputed;

  @override
  SupporterStatus get supporterStatus => (_$supporterStatusComputed ??=
          Computed<SupporterStatus>(() => super.supporterStatus,
              name: '_TipViewModel.supporterStatus'))
      .value;
  Computed<bool>? _$isSupporterComputed;

  @override
  bool get isSupporter =>
      (_$isSupporterComputed ??= Computed<bool>(() => super.isSupporter,
              name: '_TipViewModel.isSupporter'))
          .value;
  Computed<bool>? _$canJoinDiscordComputed;

  @override
  bool get canJoinDiscord =>
      (_$canJoinDiscordComputed ??= Computed<bool>(() => super.canJoinDiscord,
              name: '_TipViewModel.canJoinDiscord'))
          .value;

  late final _$tipTiersAtom =
      Atom(name: '_TipViewModel.tipTiers', context: context);

  @override
  ObservableList<TipTier>? get tipTiers {
    _$tipTiersAtom.reportRead();
    return super.tipTiers;
  }

  @override
  set tipTiers(ObservableList<TipTier>? value) {
    _$tipTiersAtom.reportWrite(value, super.tipTiers, () {
      super.tipTiers = value;
    });
  }

  late final _$visualStateAtom =
      Atom(name: '_TipViewModel.visualState', context: context);

  @override
  TipPageVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(TipPageVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$purchaseVisualStateAtom =
      Atom(name: '_TipViewModel.purchaseVisualState', context: context);

  @override
  TipPurchaseVisualState get purchaseVisualState {
    _$purchaseVisualStateAtom.reportRead();
    return super.purchaseVisualState;
  }

  @override
  set purchaseVisualState(TipPurchaseVisualState value) {
    _$purchaseVisualStateAtom.reportWrite(value, super.purchaseVisualState, () {
      super.purchaseVisualState = value;
    });
  }

  late final _$loadTipTiersAsyncAction =
      AsyncAction('_TipViewModel.loadTipTiers', context: context);

  @override
  Future<void> loadTipTiers() {
    return _$loadTipTiersAsyncAction.run(() => super.loadTipTiers());
  }

  late final _$purchaseAsyncAction =
      AsyncAction('_TipViewModel.purchase', context: context);

  @override
  Future<void> purchase(TipTier tier) {
    return _$purchaseAsyncAction.run(() => super.purchase(tier));
  }

  late final _$retryLastPurchaseAsyncAction =
      AsyncAction('_TipViewModel.retryLastPurchase', context: context);

  @override
  Future<void> retryLastPurchase() {
    return _$retryLastPurchaseAsyncAction.run(() => super.retryLastPurchase());
  }

  late final _$restorePurchasesAsyncAction =
      AsyncAction('_TipViewModel.restorePurchases', context: context);

  @override
  Future<void> restorePurchases() {
    return _$restorePurchasesAsyncAction.run(() => super.restorePurchases());
  }

  late final _$_TipViewModelActionController =
      ActionController(name: '_TipViewModel', context: context);

  @override
  void dismissPurchaseResult() {
    final _$actionInfo = _$_TipViewModelActionController.startAction(
        name: '_TipViewModel.dismissPurchaseResult');
    try {
      return super.dismissPurchaseResult();
    } finally {
      _$_TipViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _applyPurchaseOutcome(TipTier tier, PurchaseOutcome outcome) {
    final _$actionInfo = _$_TipViewModelActionController.startAction(
        name: '_TipViewModel._applyPurchaseOutcome');
    try {
      return super._applyPurchaseOutcome(tier, outcome);
    } finally {
      _$_TipViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onSupporterStatusChanged(SupporterStatus status) {
    final _$actionInfo = _$_TipViewModelActionController.startAction(
        name: '_TipViewModel._onSupporterStatusChanged');
    try {
      return super._onSupporterStatusChanged(status);
    } finally {
      _$_TipViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tipTiers: ${tipTiers},
visualState: ${visualState},
purchaseVisualState: ${purchaseVisualState},
hasAnyTipTiers: ${hasAnyTipTiers},
supporterStatus: ${supporterStatus},
isSupporter: ${isSupporter},
canJoinDiscord: ${canJoinDiscord}
    ''';
  }
}
