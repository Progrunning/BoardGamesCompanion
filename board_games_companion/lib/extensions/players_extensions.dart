import '../models/hive/player.dart';

extension PlayersExtensions on List<Player> {
  List<Player> sortAlphabetically() {
    return [...this]..sort((player, otherPlayer) => player.name!.compareTo(otherPlayer.name!));
  }
}
