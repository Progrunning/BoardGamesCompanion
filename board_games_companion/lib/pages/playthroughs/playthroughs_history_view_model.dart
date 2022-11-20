// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/playthrough_details.dart';

part 'playthroughs_history_view_model.g.dart';

@injectable
class PlaythroughsHistoryViewModel = _PlaythroughsHistoryViewModel
    with _$PlaythroughsHistoryViewModel;

abstract class _PlaythroughsHistoryViewModel with Store {
  _PlaythroughsHistoryViewModel(this._gamePlaythroughsStore);

  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;

  @observable
  ObservableFuture<void>? futureloadPlaythroughs;

  @computed
  ObservableList<PlaythroughDetails> get playthroughs {
    final sortedPlaythrough = List.of(_gamePlaythroughsStore.playthroughsDetails, growable: false);
    return ObservableList.of(sortedPlaythrough..sort((a, b) => b.startDate.compareTo(a.startDate)));
  }

  @computed
  bool get hasAnyPlaythroughs => _gamePlaythroughsStore.playthroughsDetails.isNotEmpty;

  @action
  void loadPlaythroughs() => futureloadPlaythroughs = ObservableFuture<void>(_loadPlaythroughs());

  Future<void> _loadPlaythroughs() async {
    _gamePlaythroughsStore.loadPlaythroughsDetails();
  }
}
