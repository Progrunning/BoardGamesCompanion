import 'package:board_games_companion/models/bgg/bgg_play_player.dart';

class BggPlay {
  late int id;
  late String boardGameId;
  late int? playTimeInMinutes;
  late DateTime? playDate;
  late bool completed;
  late List<BggPlayPlayer> players;
}
