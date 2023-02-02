// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_board_game_view_model.g.dart';

@injectable
class CreateBoardGameViewModel = _CreateBoardGameViewModel with _$CreateBoardGameViewModel;

abstract class _CreateBoardGameViewModel with Store {}
