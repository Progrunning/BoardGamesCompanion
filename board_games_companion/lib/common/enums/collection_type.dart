enum CollectionType {
  Owned,
  Friends,
  Wishlist,
}

extension ToString on CollectionType {
  String toHumandReadableText() {
    return toString().split('.').last;
  }
}

extension ToInt on CollectionType {
  int toInt() {
    switch (this) {
      case CollectionType.Owned:
        return 1;
      case CollectionType.Friends:
        return 2;
      case CollectionType.Wishlist:
        return 3;
      default:
        return 0;
    }
  }
}
