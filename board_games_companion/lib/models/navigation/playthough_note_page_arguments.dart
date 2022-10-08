import 'package:board_games_companion/models/hive/playthrough.dart';

class PlaythroughNotePageArguments {
  const PlaythroughNotePageArguments(this.playthrough, {this.noteId});

  final String? noteId;
  final Playthrough playthrough;
}
