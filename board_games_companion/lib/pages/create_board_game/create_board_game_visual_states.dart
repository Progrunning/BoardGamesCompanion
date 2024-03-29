import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_board_game_visual_states.freezed.dart';

@freezed
class CreateBoardGamePageVisualStates with _$CreateBoardGamePageVisualStates {
  const factory CreateBoardGamePageVisualStates.createGame() = _createGame;
  const factory CreateBoardGamePageVisualStates.editGame() = _editGame;
  const factory CreateBoardGamePageVisualStates.saving() = _saving;
  const factory CreateBoardGamePageVisualStates.removingFromCollectionsSucceeded(
      {required String boardGameName}) = _removingFromCollectionsSucceeded;
  const factory CreateBoardGamePageVisualStates.removingFromCollectionsFailed() =
      _removingFromCollectionsFailed;
  const factory CreateBoardGamePageVisualStates.saveSuccess() = _saveSuccess;
  const factory CreateBoardGamePageVisualStates.saveFailure() = _saveFailure;
}
