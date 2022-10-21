// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/playthrough_details.dart';

part 'playthroughs_history_view_model.g.dart';

@injectable
class PlaythroughsHistoryViewModel = _PlaythroughsHistoryViewModel
    with _$PlaythroughsHistoryViewModel;

abstract class _PlaythroughsHistoryViewModel with Store {
  _PlaythroughsHistoryViewModel(this._playthroughsStore);

  final PlaythroughsStore _playthroughsStore;

  @observable
  ObservableFuture<void>? futureloadPlaythroughs;

  @computed
  ObservableList<PlaythroughDetails> get playthroughs {
    final sortedPlaythrough = List.of(_playthroughsStore.playthroughsDetails, growable: false);
    return ObservableList.of(sortedPlaythrough..sort((a, b) => b.startDate.compareTo(a.startDate)));
  }

  @computed
  bool get hasAnyPlaythroughs => _playthroughsStore.playthroughsDetails.isNotEmpty;

  @action
  void loadPlaythroughs() => futureloadPlaythroughs = ObservableFuture<void>(_loadPlaythroughs());

  Future<void> _loadPlaythroughs() async {
    await _playthroughsStore.loadPlaythroughs();
  }
}