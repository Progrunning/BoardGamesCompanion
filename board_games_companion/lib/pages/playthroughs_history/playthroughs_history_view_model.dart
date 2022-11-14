// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../stores/playthroughs_store.dart';
import 'board_game_playthrough.dart';

part 'playthroughs_history_view_model.g.dart';

@injectable
class PlaythroughsHistoryViewModel = _PlaythroughsHistoryViewModel
    with _$PlaythroughsHistoryViewModel;

abstract class _PlaythroughsHistoryViewModel with Store {
  _PlaythroughsHistoryViewModel(this._playthroughsStore, this._boardGamesStore);

  final PlaythroughsStore _playthroughsStore;
  final BoardGamesStore _boardGamesStore;

  @observable
  ObservableFuture<void>? futureLoadGamesPlaythroughs;

  // TODO Group by day
  @computed
  Map<DateTime, BoardGamePlaythrough> get finishedPlaythroughs {
    return {
      for (final playthrough in _playthroughsStore.finishedPlaythroughs)
        playthrough.endDate!: BoardGamePlaythrough(
          playthrough: playthrough,
          boardGameDetails:
              _boardGamesStore.allBoardGamesInCollectionsMap[playthrough.boardGameId]!,
        )
    };
  }

  @action
  void loadGamesPlaythroughs() =>
      futureLoadGamesPlaythroughs = ObservableFuture<void>(_loadGamesPlaythroughs());

  Future<void> _loadGamesPlaythroughs() async {
    await _playthroughsStore.loadPlaythroughs();
  }
}
