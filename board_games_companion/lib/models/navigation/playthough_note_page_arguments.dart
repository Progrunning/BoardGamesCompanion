import '../hive/playthrough.dart';

class PlaythroughNotePageArguments {
  const PlaythroughNotePageArguments(this.playthrough, {this.noteId});

  final String? noteId;
  final Playthrough playthrough;
}
