// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_cat_purchase_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RevenueCatPurchaseService on _RevenueCatPurchaseService, Store {
  late final _$supporterStatusAtom = Atom(
      name: '_RevenueCatPurchaseService.supporterStatus', context: context);

  @override
  SupporterStatus get supporterStatus {
    _$supporterStatusAtom.reportRead();
    return super.supporterStatus;
  }

  @override
  set supporterStatus(SupporterStatus value) {
    _$supporterStatusAtom.reportWrite(value, super.supporterStatus, () {
      super.supporterStatus = value;
    });
  }

  late final _$_RevenueCatPurchaseServiceActionController =
      ActionController(name: '_RevenueCatPurchaseService', context: context);

  @override
  void _setSupporterStatus(SupporterStatus status) {
    final _$actionInfo = _$_RevenueCatPurchaseServiceActionController
        .startAction(name: '_RevenueCatPurchaseService._setSupporterStatus');
    try {
      return super._setSupporterStatus(status);
    } finally {
      _$_RevenueCatPurchaseServiceActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
supporterStatus: ${supporterStatus}
    ''';
  }
}
