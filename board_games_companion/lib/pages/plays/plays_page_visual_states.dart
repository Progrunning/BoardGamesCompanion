import 'package:freezed_annotation/freezed_annotation.dart';

part 'plays_page_visual_states.freezed.dart';

@freezed
class PlaysPageVisualState with _$PlaysPageVisualState {
  const factory PlaysPageVisualState.history() = _History;
  const factory PlaysPageVisualState.statistics() = _Statistics;
  const factory PlaysPageVisualState.selectGame() = _SelectGame;
}
