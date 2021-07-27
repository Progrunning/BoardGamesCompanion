import 'package:board_games_companion/common/enums/collection_flag.dart';

enum GamesTab {
  Owned,
  Friends,
  Wishlist,
}

extension ToGamesTab on int {
  GamesTab toGamesTab() {
    switch (this) {
      case 0:
        return GamesTab.Owned;
      case 1:
        return GamesTab.Friends;
      case 2:
        return GamesTab.Wishlist;
        break;
    }

    return GamesTab.Owned;
  }
}

extension ToCollectionFlag on GamesTab {
  CollectionFlag toCollectionFlag() {
    switch (this) {
      case GamesTab.Owned:
        return CollectionFlag.Owned;
      case GamesTab.Friends:
        return CollectionFlag.Friends;
        break;
      case GamesTab.Wishlist:
        return CollectionFlag.Wishlist;
        break;
    }

    return CollectionFlag.Owned;
  }
}
