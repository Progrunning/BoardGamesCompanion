import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_page_visual_state.freezed.dart';

/// Visual state for loading the list of tip tiers from [PurchaseService].
@freezed
class TipPageVisualState with _$TipPageVisualState {
  const factory TipPageVisualState.loading() = _loading;
  const factory TipPageVisualState.loaded() = _loaded;
  const factory TipPageVisualState.failedLoading() = _failedLoading;
}
