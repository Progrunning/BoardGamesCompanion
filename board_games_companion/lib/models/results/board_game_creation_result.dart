import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_creation_result.freezed.dart';

@freezed
class GameCreationResult with _$GameCreationResult {
  const factory GameCreationResult.saveSuccess({
    required String boardGameId,
    required String boardGameName,
  }) = _saveSuccess;
  const factory GameCreationResult.removingFromCollectionsSucceeded({
    required String boardGameName,
  }) = _removingFromCollectionsSucceeded;
  const factory GameCreationResult.cancelled() = _cancelled;
  const factory GameCreationResult.failure() = _failure;
}
