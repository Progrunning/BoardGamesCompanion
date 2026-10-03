import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_purchase_visual_state.freezed.dart';

/// Visual state of an in-flight (or just-finished) tip purchase, distinct
/// from [TipPageVisualState] which only tracks loading the tier list.
@freezed
class TipPurchaseVisualState with _$TipPurchaseVisualState {
  const factory TipPurchaseVisualState.idle() = _idle;
  const factory TipPurchaseVisualState.purchasing() = _purchasing;
  const factory TipPurchaseVisualState.pending() = _pending;
  const factory TipPurchaseVisualState.completed() = _completed;
  const factory TipPurchaseVisualState.failed() = _failed;
}
