import 'package:board_games_companion/common/enums/collection_type.dart';

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

extension ToCollectionType on GamesTab {
  CollectionType toCollectionFlag() {
    switch (this) {
      case GamesTab.Owned:
        return CollectionType.Owned;
      case GamesTab.Friends:
        return CollectionType.Friends;
        break;
      case GamesTab.Wishlist:
        return CollectionType.Wishlist;
        break;
    }

    return CollectionType.Owned;
  }
}
