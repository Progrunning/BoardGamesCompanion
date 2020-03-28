extension IntExtensions on int {
  String toOrdinalAbbreviations() {
    if (this == null) {
      return '';
    }

    switch (this % 100) {
      case 11:
      case 12:
      case 13:
        return "th";
      default:
        switch (this % 10) {
          case 1:
            return "st";
          case 2:
            return "nd";
          case 3:
            return "rd";
          default:
            return "th";
        }
    }
  }
}
