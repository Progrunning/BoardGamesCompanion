import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class AppColors {
  static const Color defaultTextColor = whiteColor;
  static const Color secondaryTextColor = greyColor;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color blueColor = Colors.blue;
  static const Color redColor = Colors.red;
  static const Color greenColor = Colors.green;
  static const Color pinkColor = Colors.pink;
  static const Color purpleColor = Colors.purple;
  static const Color greyColor = Colors.grey;
  static Color darkGreyColor = Colors.grey.shade800;

  static const Color primaryColorLight = Color(0xFF5B217F);
  static const Color primaryColor = Color(0xFF2D103F);

  static const Color accentColor = Color(0xFFFF9800);

  static const Color secondaryColor = Color(0xFF010055);
  static const Color secondaryLightColor = Color(0xFF2747A5);

  static const Color shadowColor = blackColor;

  static const Color invertedTextColor = blackColor;

  static const Color dialogBackgroundColor = Color(0x80000000);

  static const Color bottomTabBackgroundColor = primaryColorLight;
  static const Color selectedTabIconColor = accentColor;
  static const Color deselectedTabIconColor = Color(0x46FFFFFF);

  static const Color enabledIconIconColor = accentColor;
  static const Color disabledIconIconColor = Color(0x46FFFFFF);

  static const Color startDefaultPageBackgroundColorGradient = primaryColorLight;
  static const Color endDefaultPageBackgroundColorGradient = primaryColor;

  static const Color startDefaultPageElementBackgroundColorGradient = secondaryLightColor;
  static const Color endDefaultPageElementBackgroundColorGradient = secondaryColor;

  static const Color activeBottomTabColor = whiteColor;
  static const Color inactiveBottomTabColor = greyColor;

  static const Color inactiveWinningConditionIcon = greyColor;
  static const Color activeWinningConditionIcon = accentColor;

  static Color alternativeSplashColor = primaryColorLight.withOpacity(0.7);

  static Color playedGamesStatColor = chartColorPallete[0];
  static Color highscoreStatColor = chartColorPallete[1];
  static Color averagePlayerCountStatColor = chartColorPallete[5];
  static Color averageScoreStatColor = chartColorPallete[3];
  static Color averagePlaytimeStatColor = chartColorPallete[2];
  static Color totalPlaytimeStatColor = chartColorPallete[6];

  static const List<Color> chartColorPallete = <Color>[
    Color(0xFF1784A4),
    Color(0xFFC84634),
    Color(0xFF9ED86B),
    Color(0xFFF5C766),
    Color(0xFF6F4E7B),
    Color(0xFF8FDDD0),
    Color(0xFFFD9F5C),
    Color(0xFF003f5c),
    Color(0xFF2f4b7c),
    Color(0xFF665191),
    Color(0xFFa05195),
    Color(0xFFd45087),
    Color(0xFFf95d6a),
    Color(0xFFff7c43),
    Color(0xFFffa600),
  ];
}
