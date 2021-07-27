enum CollectionFlag {
  Owned,
  Friends,
  Wishlist,
}

extension ToString on CollectionFlag {
  String toHumandReadableText() {
    return toString().split('.').last;
  }
}

extension ToInt on CollectionFlag {
  int toInt() {
    switch (this) {
      case CollectionFlag.Owned:
        return 1;
      case CollectionFlag.Friends:
        return 2;
      case CollectionFlag.Wishlist:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
