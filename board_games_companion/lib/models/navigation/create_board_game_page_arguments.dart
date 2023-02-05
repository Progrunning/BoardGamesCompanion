import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_board_game_page_arguments.freezed.dart';

@freezed
abstract class CreateBoardGamePageArguments with _$CreateBoardGamePageArguments {
  const factory CreateBoardGamePageArguments({required String boardGameName}) =
      _CreateBoardGamePageArguments;

  const CreateBoardGamePageArguments._();
}
