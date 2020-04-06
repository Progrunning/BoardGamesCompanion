import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColorLight = const Color(0xFF5B217F);
  static const Color primaryColor = const Color(0xFF41175B);
  static const Color accentColor = Colors.orange;

  static const Color secondaryColor = const Color(0xFF010055);
  static const Color secondaryLightColor = const Color(0xFF2747A5);

  static const Color shadowColor = const Color(0xFF000000);

  static const Color defaultTextColor = Color(0xFFFFFFFF);
  static const Color inverterTextColor = Color(0xFF000000);
  
  static const Color secondaryTextColor = Colors.grey;

  static const Color bottomTabBackgroundColor = primaryColorLight;
  static const Color selectedBottomTabIconColor = defaultTextColor;
  static const Color deselectedBottomTabIconColor = Color(0x46FFFFFF);

  static const Color endDefaultPageBackgroundColorGradient = primaryColor;
  static const Color startDefaultPageBackgroundColorGradient =
      primaryColorLight;

  static const Color startDefaultPageElementBackgroundColorGradient =
      secondaryLightColor;
  static const Color endDefaultPageElementBackgroundColorGradient =
      secondaryColor;

  static const TextStyle defaultBottomTabItemTextStyle = TextStyle(
    color: defaultTextColor,
  );
  
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: Dimensions.mediumFontSize,
    color: defaultTextColor,
  );
  
  static const TextStyle subTitleTextStyle = TextStyle(
    fontSize: Dimensions.standardSpacing,
    color: secondaryTextColor,
  );

  static ThemeData get theme {
    final originalTextTheme = ThemeData.light().textTheme;
    final originalInputDecorationTheme = ThemeData.light().inputDecorationTheme;
    final originalBody1 = originalTextTheme.body1;
    final originalDisplay1 = originalTextTheme.display1;
    final originalDisplay2 = originalTextTheme.display2;
    final originalDisplay3 = originalTextTheme.display3;
    final originalDisplay4 = originalTextTheme.display4;
    final originalSubhead = originalTextTheme.subhead;

    return new ThemeData.light().copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      accentColor: accentColor,
      buttonColor: accentColor,
      textSelectionColor: Colors.cyan[100],
      backgroundColor: Colors.grey[800],
      textTheme: originalTextTheme.copyWith(
        body1: originalBody1.copyWith(
          decorationColor: Colors.transparent,
          color: defaultTextColor,
        ),
        display1: originalDisplay1.copyWith(
          fontSize: Dimensions.standardFontSize,
          color: defaultTextColor,
        ),
        display2: originalDisplay2.copyWith(
          fontSize: Dimensions.mediumFontSize,
          color: defaultTextColor,
        ),
        display3: originalDisplay3.copyWith(
          fontSize: Dimensions.largeFontSize,
          color: defaultTextColor,
        ),
        display4: originalDisplay4.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: defaultTextColor,
        ),
        subhead: originalSubhead.copyWith(
          fontSize: Dimensions.standardFontSize,
          color: secondaryTextColor,
        ),
      ),
      inputDecorationTheme: originalInputDecorationTheme.copyWith(
        labelStyle: TextStyle(
          color: defaultTextColor,
        ),
      ),
    );
  }
}
