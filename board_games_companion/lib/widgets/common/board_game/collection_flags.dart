import 'package:flutter/material.dart';

import '../../../common/app_text.dart';
import '../../../common/enums/collection_type.dart';
import '../collection_toggle_button.dart';

class CollectionFlags extends StatelessWidget {
  const CollectionFlags({
    required this.isEditable,
    required this.isOwned,
    required this.isOnWishlist,
    required this.isOnFriendsList,
    required this.onToggleCollection,
    Key? key,
  }) : super(key: key);

  final bool isEditable;
  final bool isOwned;
  final bool isOnWishlist;
  final bool isOnFriendsList;
  final void Function(CollectionType) onToggleCollection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [isOnFriendsList, isOnWishlist],
          children: <Widget>[
            CollectionToggleButton(
              icon: Icons.group,
              title: AppText.friendsCollectionToggleButtonText,
              isSelected: isOnFriendsList,
            ),
            CollectionToggleButton(
              icon: Icons.card_giftcard,
              title: AppText.whishlistCollectionToggleButtonText,
              isSelected: isOnWishlist,
            ),
          ],
          onPressed: (int index) => isEditable
              ? onToggleCollection(
                  index == 0 ? CollectionType.friends : CollectionType.wishlist,
                )
              : null,
        ),
        ToggleButtons(
          isSelected: [isOwned],
          children: <Widget>[
            CollectionToggleButton(
              icon: Icons.grid_on,
              title: AppText.ownedCollectionToggleButtonText,
              isSelected: isOwned,
            ),
          ],
          onPressed: (int index) => isEditable ? onToggleCollection(CollectionType.owned) : null,
        ),
      ],
    );
  }
}
