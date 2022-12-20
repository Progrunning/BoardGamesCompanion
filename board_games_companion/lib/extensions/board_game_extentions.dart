import 'package:board_games_companion/models/hive/board_game_details.dart';

import '../common/enums/collection_type.dart';

extension BoardGameDetailsExtensions on Iterable<BoardGameDetails> {
  Iterable<BoardGameDetails> inCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.owned:
        return where((boardGame) => boardGame.isOwned ?? false);
      case CollectionType.friends:
        return where((boardGame) => boardGame.isFriends ?? false);
      case CollectionType.wishlist:
        return where((boardGame) => boardGame.isOnWishlist ?? false);
    }
  }
}
