// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'playthroughs_store.g.dart';

@singleton
class PlaythroughsStore = _PlaythroughsStore with _$PlaythroughsStore;

abstract class _PlaythroughsStore with Store {
  _PlaythroughsStore(this._playthroughService);

  final PlaythroughService _playthroughService;

  @observable
  ObservableList<Playthrough> playthroughs = ObservableList.of([]);

  @computed
  List<Playthrough> get finishedPlaythroughs =>
      playthroughs.where((p) => p.status == PlaythroughStatus.Finished).toList();

  @computed
  List<Playthrough> get ongoingPlaythroughs =>
      playthroughs.where((p) => p.status == PlaythroughStatus.Started).toList();

  Future<void> loadPlaythroughs() async {
    try {
      playthroughs = ObservableList.of(await _playthroughService.retrievePlaythroughs());
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
