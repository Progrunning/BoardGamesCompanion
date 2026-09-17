import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_restore_visual_state.freezed.dart';

/// Visual state of a restore-purchases attempt - a failed restore must be
/// visibly different from "you never tipped", and a finished one needs a
/// confirmation even when no entitlement was found.
@freezed
class TipRestoreVisualState with _$TipRestoreVisualState {
  const factory TipRestoreVisualState.idle() = _idle;
  const factory TipRestoreVisualState.restoring() = _restoring;
  const factory TipRestoreVisualState.restored() = _restored;
  const factory TipRestoreVisualState.failed() = _failed;
}
