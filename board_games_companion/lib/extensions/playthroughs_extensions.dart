import 'package:board_games_companion/models/hive/playthrough.dart';

extension PlaythroughsExtensions on Iterable<Playthrough> {
  double get averageNumberOfPlayers =>
      map((Playthrough p) => p.playerIds.length).reduce((a, b) => a + b) / length;

  int get totalPlaytimeInSeconds =>
      map((Playthrough p) => p.endDate!.difference(p.startDate).inSeconds).reduce((a, b) => a + b);

  Iterable<Playthrough> get sortedByStartDate => [...this]..sort((playthrough, otherPlaythrough) =>
      playthrough.startDate.compareTo(otherPlaythrough.startDate));

  DateTime get lastTimePlayed => mostRecentPlaythrough.startDate;

  Playthrough get mostRecentPlaythrough => sortedByStartDate.last;

  int get averagePlaytimeInSeconds => (totalPlaytimeInSeconds / length).floor();
}
