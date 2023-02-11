// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/collection_type.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/board_game_details.dart';
import 'create_board_game_visual_states.dart';

part 'create_board_game_view_model.g.dart';

@injectable
class CreateBoardGameViewModel = _CreateBoardGameViewModel with _$CreateBoardGameViewModel;

abstract class _CreateBoardGameViewModel with Store {
  _CreateBoardGameViewModel(this._boardGamesStore);

  final BoardGamesStore _boardGamesStore;
  late BoardGameDetails _boardGame;

  @observable
  CreateBoardGamePageVisualStates visualState = const CreateBoardGamePageVisualStates.editGame();

  @observable
  BoardGameDetails? _boardGameWorkingCopy;

  @observable
  String? _boardGameName;

  @computed
  BoardGameDetails get boardGame => _boardGameWorkingCopy ??= _boardGame = BoardGameDetails(
        id: const Uuid().v4(),
        name: '',
        isCreatedByUser: true,
      );

  @computed
  bool get hasUnsavedChanges => boardGame != _boardGame;

  @action
  void setBoardGameId(String id) =>
      _boardGameWorkingCopy = _boardGame = _boardGamesStore.allBoardGamesMap[id]!;

  @action
  void setBoardGameName(String name) => _boardGameWorkingCopy = boardGame.copyWith(name: name);

  @action
  void setBoardGameImage(String imageUri) =>
      _boardGameWorkingCopy = boardGame.copyWith(imageUrl: imageUri);

  @action
  void toggleCollection(CollectionType collectionType) =>
      _boardGameWorkingCopy = boardGame.toggleCollection(collectionType);

  @action
  Future<void> saveBoardGame() async {
    try {
      visualState = const CreateBoardGamePageVisualStates.saving();
      await _boardGamesStore.addOrUpdateBoardGame(boardGame);
      visualState = const CreateBoardGamePageVisualStates.saveSuccess();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      visualState = const CreateBoardGamePageVisualStates.saveFailure();
    }
  }
}
