enum CollectionFlag {
  Colleciton,
  Played,
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
      case CollectionFlag.Colleciton:
        return 1;
      case CollectionFlag.Played:
        return 2;
      case CollectionFlag.Wishlist:
        return 3;
        break;
      default:
        return 0;
    }
  }
}
