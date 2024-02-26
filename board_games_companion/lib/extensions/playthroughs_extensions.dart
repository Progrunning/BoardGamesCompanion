import 'package:board_games_companion/common/constants.dart';

import '../models/hive/playthrough.dart';

extension PlaythroughsExtensions on Iterable<Playthrough> {
  double get averageNumberOfPlayers =>
      map((Playthrough p) => p.playerIds.length).reduce((a, b) => a + b) / length;

  int get totalPlaytimeInSeconds =>
      map((Playthrough p) => p.endDate!.difference(p.startDate).inSeconds).reduce((a, b) => a + b);

  Iterable<Playthrough> get sortedByStartDate => [...this]..sort((playthrough, otherPlaythrough) =>
      otherPlaythrough.startDate.compareTo(playthrough.startDate));

  Iterable<Playthrough> get sortedByEndDate => [...this]..sort((playthrough, otherPlaythrough) {
      if (playthrough.endDate == null && otherPlaythrough.endDate != null) {
        return Constants.moveBelow;
      }

      if (playthrough.endDate != null && otherPlaythrough.endDate == null) {
        return Constants.moveAbove;
      }

      if (playthrough.endDate == null && otherPlaythrough.endDate == null) {
        return Constants.leaveAsIs;
      }

      return playthrough.endDate!.compareTo(otherPlaythrough.endDate!);
    });

  DateTime get lastTimePlayed => mostRecentPlaythrough.startDate;

  Playthrough get mostRecentPlaythrough => sortedByStartDate.first;

  int get averagePlaytimeInSeconds => (totalPlaytimeInSeconds / length).floor();
}
