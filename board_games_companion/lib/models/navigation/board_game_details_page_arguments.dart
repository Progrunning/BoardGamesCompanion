class BoardGameDetailsPageArguments {
  const BoardGameDetailsPageArguments(
    this.boardGameId,
    this.boardGameName,
    this.navigatingFromType, {
    this.boardGameImageUrl,
  });

  final String boardGameId;
  final String boardGameName;
  final String? boardGameImageUrl;
  final Type navigatingFromType;
}
