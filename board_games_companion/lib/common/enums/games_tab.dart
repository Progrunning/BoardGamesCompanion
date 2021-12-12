import 'collection_type.dart';

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
    }

    return GamesTab.Owned;
  }
}

extension ToCollectionType on GamesTab {
  CollectionType toCollectionType() {
    switch (this) {
      case GamesTab.Owned:
        return CollectionType.Owned;
      case GamesTab.Friends:
        return CollectionType.Friends;
      case GamesTab.Wishlist:
        return CollectionType.Wishlist;
    }
  }
}
