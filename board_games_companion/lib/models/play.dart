import 'package:board_games_companion/models/play_players.dart';

class Play {
  late int id;
  late String boardGameId;
  late int? playTimeInMinutes;
  late DateTime? playDate;
  late bool completed;
  late List<PlayPlayer> players;
}
