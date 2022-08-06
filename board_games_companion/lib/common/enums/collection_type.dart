enum CollectionType {
  owned,
  friends,
  wishlist,
}

extension ToString on CollectionType {
  String toHumandReadableText() {
    return toString().split('.').last;
  }
}

extension ToInt on CollectionType {
  int toInt() {
    switch (this) {
      case CollectionType.owned:
        return 1;
      case CollectionType.friends:
        return 2;
      case CollectionType.wishlist:
        return 3;
      default:
        return 0;
    }
  }
}
