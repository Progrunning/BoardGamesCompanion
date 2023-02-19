// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/enums/collection_type.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../common/regex_expressions.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/file_service.dart';
import 'create_board_game_visual_states.dart';

part 'create_board_game_view_model.g.dart';

@injectable
class CreateBoardGameViewModel = _CreateBoardGameViewModel with _$CreateBoardGameViewModel;

abstract class _CreateBoardGameViewModel with Store {
  _CreateBoardGameViewModel(this._boardGamesStore, this._fileService);

  static const int _defaultNumberOfPlayers = 1;
  static const int _defaultPlaytimeInMinutes = 30;

  final BoardGamesStore _boardGamesStore;
  final FileService _fileService;

  late BoardGameDetails _boardGame;

  XFile? _boardGameImageFile;

  @observable
  CreateBoardGamePageVisualStates visualState = const CreateBoardGamePageVisualStates.editGame();

  @observable
  BoardGameDetails? _boardGameWorkingCopy;

  @observable
  String? _boardGameName;

  /// Returns the working copy [_boardGameWorkingCopy] of a game. Created a board game with
  /// default arbitrary values in case it hasn't been yet initialized.
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

    _boardGameWorkingCopy = boardGame.copyWith(
      imageUrl: imageFile.path,
      thumbnailUrl: imageFile.path,
    );
  }

  @action
  Future<void> saveBoardGame() async {
    try {
      visualState = const CreateBoardGamePageVisualStates.saving();
      final savedImagePath = await _saveBoardGameImage();
      if (savedImagePath != null) {
        // MK Delete previous image
        if (_boardGame.imageUrl != null) {
          await _deleteBoardGameImage(_boardGame.imageUrl!);
        }

        _boardGameWorkingCopy = boardGame.copyWith(
          imageUrl: savedImagePath,
          thumbnailUrl: savedImagePath,
        );
      }
      await _boardGamesStore.addOrUpdateBoardGame(boardGame);
      visualState = const CreateBoardGamePageVisualStates.saveSuccess();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      visualState = const CreateBoardGamePageVisualStates.saveFailure();
    }
  }

  Future<String?> _saveBoardGameImage() async {
    if (boardGame.imageUrl.isNullOrBlank || _boardGameImageFile == null) {
      return null;
    }

    final imageName = const Uuid().v4();
    String? imageFileExtension = '.${Constants.jpgFileExtension}';
    if (RegexExpressions.findFileExtensionRegex.hasMatch(_boardGameImageFile!.path)) {
      imageFileExtension =
          RegexExpressions.findFileExtensionRegex.firstMatch(_boardGameImageFile!.path)!.group(0);
    }

    final fileName = '$imageName$imageFileExtension';
    final File? savedImage = await _fileService.saveToDocumentsDirectory(
      fileName,
      _boardGameImageFile!,
      filePath: 'images/boardGames',
    );

    return savedImage?.uri.path;
  }

  Future<void> _deleteBoardGameImage(String imageFilePath) async {
    if (imageFilePath.isNullOrBlank) {
      return;
    }

    try {
      await _fileService.deleteFile(imageFilePath);
    } on Exception catch (e, stack) {
      // MK Swallow the error as deleting previous images is non essential but log an error about it.
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
