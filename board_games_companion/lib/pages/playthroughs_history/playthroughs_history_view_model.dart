// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/playthrough_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../stores/playthroughs_store.dart';
import 'board_game_playthrough.dart';
import 'grouped_board_game_playthroughs.dart';

part 'playthroughs_history_view_model.g.dart';

@injectable
class PlaythroughsHistoryViewModel = _PlaythroughsHistoryViewModel
    with _$PlaythroughsHistoryViewModel;

abstract class _PlaythroughsHistoryViewModel with Store {
  _PlaythroughsHistoryViewModel(
    this._playthroughsStore,
    this._boardGamesStore,
    this._playersStore,
  );

  final PlaythroughsStore _playthroughsStore;
  final BoardGamesStore _boardGamesStore;
  final PlayersStore _playersStore;

  final DateFormat playthroughGroupingDateFormat = DateFormat.yMd();

  @observable
  ObservableFuture<void>? futureLoadGamesPlaythroughs;

  @computed
  List<GroupedBoardGamePlaythroughs> get finishedBoardGamePlaythroughs {
    final result = <GroupedBoardGamePlaythroughs>[];
    final finishedPlaythroughsGrouped = groupBy(
        _playthroughsStore.finishedPlaythroughs
          ..sort((playthroughA, playthroughB) =>
              playthroughB.endDate!.compareTo(playthroughA.endDate!)),
        (Playthrough playthrough) => playthroughGroupingDateFormat.format(playthrough.endDate!));

    for (final playthroughsEntry in finishedPlaythroughsGrouped.entries) {
      result.add(
        GroupedBoardGamePlaythroughs(
          date: playthroughGroupingDateFormat.parse(playthroughsEntry.key),
          boardGamePlaythroughs: playthroughsEntry.value
              .map((playthrough) => BoardGamePlaythrough(
                    playthrough: PlaythroughDetails(
                      playthrough: playthrough,
                      // TODO Need to get scores
                      // TODO Need to do a load on scroll
                      playerScores: [
                        // for (final playerId in playthrough.playerIds)
                        //   _playersStore.playersById[playerId]
                      ],
                    ),
                    boardGameDetails:
                        _boardGamesStore.allBoardGamesInCollectionsMap[playthrough.boardGameId]!,
                  ))
              .toList(),
        ),
      );
    }

    return result;
  }

  @action
  void loadGamesPlaythroughs() =>
      futureLoadGamesPlaythroughs = ObservableFuture<void>(_loadGamesPlaythroughs());

  Future<void> _loadGamesPlaythroughs() async {
    await _playthroughsStore.loadPlaythroughs();
  }
}
