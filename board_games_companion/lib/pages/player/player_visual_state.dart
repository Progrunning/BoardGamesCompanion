import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_visual_state.freezed.dart';

@freezed
class PlayerVisualState with _$PlayerVisualState {
  const factory PlayerVisualState.init() = Init;
  const factory PlayerVisualState.create() = Create;
  const factory PlayerVisualState.edit() = Edit;
  const factory PlayerVisualState.deleted() = Deleted;
  const factory PlayerVisualState.restored() = Restored;

  const PlayerVisualState._();

  bool get isEditMode => switch (this) {
        Edit() => true,
        _ => false,
      };

  bool get isDeleted => switch (this) {
        Deleted() => true,
        _ => false,
      };
}
