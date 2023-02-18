// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/collection_type.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
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

  static const int _defaultNumberOfPlayers = 1;
  static const int _defaultPlaytimeInMinutes = 30;

  final BoardGamesStore _boardGamesStore;
  late BoardGameDetails _boardGame;

  XFile? _boardGameImageFile;

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
        isOwned: true,
        minPlayers: 1,
        maxPlayers: 1,
        minPlaytime: 30,
        maxPlaytime: 60,
      );

  @computed
  bool get hasUnsavedChanges => boardGame != _boardGame;

  @computed
  double? get rating => boardGame.rating;

  @computed
  int get minPlayers => boardGame.minPlayers ?? _defaultNumberOfPlayers;

  @computed
  int get maxPlayers => boardGame.maxPlayers ?? _defaultNumberOfPlayers;

  @computed
  int get minPlaytime => boardGame.minPlaytime ?? _defaultPlaytimeInMinutes;

  @computed
  int get maxPlaytime => boardGame.maxPlaytime ?? _defaultPlaytimeInMinutes;

  @computed
  int? get minAge => boardGame.minAge;

  @computed
  bool get isValid => boardGame.name.isNotEmpty && boardGame.isInAnyCollection;

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
  void updateRating(double? rating) => _boardGameWorkingCopy = boardGame.copyWith(rating: rating);

  @action
  void updateNumberOfPlayers(int minPlayers, int maxPlayers) =>
      _boardGameWorkingCopy = boardGame.copyWith(minPlayers: minPlayers, maxPlayers: maxPlayers);

  @action
  void updatePlaytime(int minPlaytime, int maxPlaytime) => _boardGameWorkingCopy =
      boardGame.copyWith(minPlaytime: minPlaytime, maxPlaytime: maxPlaytime);

  @action
  void updateMinAge(int? minAge) => _boardGameWorkingCopy = boardGame.copyWith(minAge: minAge);

  @action
  void updateImage(XFile imageFile) {
    _boardGameImageFile = imageFile;

    // TODO Consider resizing the game image for the thumbnail
    _boardGameWorkingCopy = boardGame.copyWith(
      imageUrl: imageFile.path,
      thumbnailUrl: imageFile.path,
    );
  }

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
