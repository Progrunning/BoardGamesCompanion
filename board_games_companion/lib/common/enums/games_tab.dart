import 'package:board_games_companion/common/enums/collection_flag.dart';

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

extension ToCollectionFlag on GamesTab {
  CollectionFlag toCollectionFlag() {
    switch (this) {
      case GamesTab.Colleciton:
        return CollectionFlag.Colleciton;
      case GamesTab.Played:
        return CollectionFlag.Played;
        break;
      case GamesTab.Wishlist:
        return CollectionFlag.Wishlist;
        break;
    }

    return CollectionFlag.Colleciton;
  }
}
