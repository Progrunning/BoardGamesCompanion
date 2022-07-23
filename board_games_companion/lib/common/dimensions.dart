import 'package:flutter/material.dart';

class Dimensions {
  static const double quarterStandardSpacing = standardSpacing / 4;
  static const double halfStandardSpacing = standardSpacing / 2;
  static const double standardSpacing = 8;
  static const double doubleStandardSpacing = standardSpacing * 2;
  static const double trippleStandardSpacing = standardSpacing * 3;

  static const double boardGameDetailsImageHeight = 80;

  static const double extraSmallFontSize = 10;
  static const double smallFontSize = 12;
  static const double standardFontSize = 14;
  static const double mediumFontSize = 16;
  static const double largeFontSize = 18;
  static const double extraLargeFontSize = 20;
  static const double doubleExtraLargeFontSize = 26;

  static const double boardGameItemCollectionImageWidth = 150;
  static const double boardGameItemCollectionImageHeight = 150;

  static const double collectionSearchResultBoardGameImageHeight = 100;
  static const double collectionSearchResultBoardGameImageWidth = 100;

  static const double boardGameRemoveIconSize = 40;

  static const double boardGameDetailsLinkIconSize = 40;

  static const double boardGameDetailsHexagonFontSize = 30;
  static const double boardGameDetailsHexagonSize = 88;
  static const double boardGameHexagonSize = 40;
  static const double collectionFilterHexagonSize = 32;

  static const int edgeNumberOfHexagon = 6;

  static const double defaultPlayerAvatarSize = 150;
  static const double smallPlayerAvatarSize = 100;
  static const double smallPlayerAvatarWithScoreSize = 140;
  static const double searchResultsPlayerAvatarSize = 80;

  static const double defaultButtonIconSize = 20;
  static const double defaultCheckboxSize = 24;

  static const double floatingActionButtonBottomSpacing = 72;
  static const double halfFloatingActionButtonBottomSpacing = floatingActionButtonBottomSpacing / 2;

  static const double defaultBorderWidth = 1.5;

  static const double defaultElevation = 3;

  static const double bottomTabTopHeight = 20;

  static const EdgeInsets snackbarMargin = EdgeInsets.only(
    left: Dimensions.standardSpacing,
    right: Dimensions.standardSpacing,
    bottom: Dimensions.standardSpacing + Dimensions.bottomTabTopHeight,
  );
}
