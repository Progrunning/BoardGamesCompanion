import 'package:freezed_annotation/freezed_annotation.dart';

enum BoardGameType {
  @JsonValue('BoardGame')
  boardGame,
  @JsonValue('Expansion')
  expansion,
}
