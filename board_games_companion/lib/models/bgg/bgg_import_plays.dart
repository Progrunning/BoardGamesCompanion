class BggImportPlays {
  BggImportPlays(this.username, this.boardGameId, {this.pageNumber = 1});

  late String username;
  late String boardGameId;
  late int pageNumber;
}
