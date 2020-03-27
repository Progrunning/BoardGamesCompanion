import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class PlaythroughsStore with ChangeNotifier {
  final PlaythroughService _playthroughService;

  BoardGameDetails _selectedBoardGame;
  LoadDataState _loadDataState;
  List<Playthrough> _playthroughs;

  PlaythroughsStore(this._playthroughService);

  BoardGameDetails get selectedBoardGame => _selectedBoardGame;

  LoadDataState get loadDataState => _loadDataState;

  List<Playthrough> get playthroughs => _playthroughs;

  Future<void> loadPlaythroughs(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      _loadDataState = LoadDataState.Error;
      notifyListeners();

      return;
    }

    _selectedBoardGame = boardGameDetails;
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _playthroughs =
          await _playthroughService.retrievePlaythroughs(_selectedBoardGame.id);
      _loadDataState = LoadDataState.Loaded;
    } catch (e, stack) {
      _loadDataState = LoadDataState.Error;
      Crashlytics.instance.recordError(e, stack);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _playthroughService.closeBox(HiveBoxes.Playthroughs);
    super.dispose();
  }
}
