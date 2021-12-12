class BoardGameDetailsPageArguments {
  const BoardGameDetailsPageArguments(
    this.boardGameId,
    this.boardGameName,
    this.navigatingFromType,
  );

  final String boardGameId;
  final String boardGameName;
  final Type navigatingFromType;
}
