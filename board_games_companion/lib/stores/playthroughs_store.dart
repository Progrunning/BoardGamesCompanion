import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class PlaythroughsStore with ChangeNotifier {
  final PlaythroughService _playthroughService;

  String _selectedBoardGameId;
  LoadDataState _loadDataState;
  List<Playthrough> _playthroughs;

  PlaythroughsStore(this._playthroughService);

  String get selectedBoardGameId => _selectedBoardGameId;

  LoadDataState get loadDataState => _loadDataState;

  List<Playthrough> get playthroughs => _playthroughs;

  Future<void> loadPlaythroughs(String boardGameId) async {
    if (boardGameId?.isEmpty ?? true) {
      _loadDataState = LoadDataState.Error;
      notifyListeners();

      return;
    }

    _selectedBoardGameId = boardGameId;
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _playthroughs =
          await _playthroughService.retrievePlaythroughs(_selectedBoardGameId);
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
