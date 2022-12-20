import 'collection_type.dart';

enum GamesTab {
  owned,
  friends,
  wishlist,
}

extension ToGamesTab on int {
  GamesTab toCollectionsTab() {
    switch (this) {
      case 0:
        return GamesTab.owned;
      case 1:
        return GamesTab.friends;
      case 2:
        return GamesTab.wishlist;
    }

    return GamesTab.owned;
  }
}

extension ToCollectionType on GamesTab {
  CollectionType toCollectionType() {
    switch (this) {
      case GamesTab.owned:
        return CollectionType.owned;
      case GamesTab.friends:
        return CollectionType.friends;
      case GamesTab.wishlist:
        return CollectionType.wishlist;
    }
  }
}
