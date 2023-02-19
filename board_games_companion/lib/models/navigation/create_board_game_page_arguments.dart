import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_board_game_page_arguments.freezed.dart';

/// Specify [boardGameId] to toggle edit mode.
@freezed
abstract class CreateBoardGamePageArguments with _$CreateBoardGamePageArguments {
  const factory CreateBoardGamePageArguments({
    String? boardGameName,
    String? boardGameId,
  }) = _CreateBoardGamePageArguments;

  const CreateBoardGamePageArguments._();
}
