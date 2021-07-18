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
