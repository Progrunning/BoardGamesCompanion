// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_board_game_view_model.g.dart';

@injectable
class CreateBoardGameViewModel = _CreateBoardGameViewModel with _$CreateBoardGameViewModel;

abstract class _CreateBoardGameViewModel with Store {
  @observable
  String? _boardGameName;

  @computed
  String get boardGameName => _boardGameName ?? '';

  @observable
  String? boardGameImageUri;

  @action
  void setBoardGameName(String boardGameName) => _boardGameName = boardGameName;

  @action
  void setBoardGameImage(String boardGameImageUri) => this.boardGameImageUri = boardGameImageUri;

  @action
  void saveBoardGame() {}
}
