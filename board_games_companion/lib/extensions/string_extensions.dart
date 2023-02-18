import '../common/constants.dart';

extension StringExtensions on String? {
  int safeCompareTo(String? stringToCompare) {
    if (this == null && stringToCompare == null) {
      return Constants.leaveAsIs;
    }

    if (this != null && stringToCompare == null) {
      return Constants.moveAbove;
    }

    if (this == null && stringToCompare != null) {
      return Constants.moveBelow;
    }

    return this!.compareTo(stringToCompare!);
  }

  String toCapitalized() {
    if (this == null) {
      return '';
    }

    return this!.isNotEmpty ? '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}' : '';
  }

  /// Check if [Uri] can be parsed and if it can if it has the scheme (i.e. http or https) defined.
  /// If it doesn't it's not a web url.
  bool isWebUrl() {
    if (this == null) {
      return false;
    }

    final uri = Uri.tryParse(this!);
    return uri != null && uri.hasScheme && uri.host.isEmpty;
  }
}
