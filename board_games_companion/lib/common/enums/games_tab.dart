enum GamesTab {
  Colleciton,
  Played,
  Wishlist,
}

extension ToGamesTab on int {
  GamesTab toGamesTab() {
    switch (this) {
      case 0:
        return GamesTab.Colleciton;
      case 1:
        return GamesTab.Played;
      case 2:
        return GamesTab.Wishlist;
        break;
    }

    return GamesTab.Colleciton;
  }
}
