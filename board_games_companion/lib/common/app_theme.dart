import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static const Color primaryColorLight = Color(0xFF5B217F);
  static const Color primaryColor = Color(0xFF2D103F);

  static const Color accentColor = Color(0xFFFF9800);

  static const Color secondaryColor = Color(0xFF010055);
  static const Color secondaryLightColor = Color(0xFF2747A5);

  static const Color shadowColor = Color(0xFF000000);

  static const Color defaultTextColor = Color(0xFFFFFFFF);
  static const Color inverterTextColor = Color(0xFF000000);

  static const Color secondaryTextColor = Colors.grey;

  static const Color bottomTabBackgroundColor = primaryColorLight;
  static const Color selectedTabIconColor = accentColor;
  static const Color deselectedTabIconColor = Color(0x46FFFFFF);

  static const Color endDefaultPageBackgroundColorGradient = primaryColor;
  static const Color startDefaultPageBackgroundColorGradient = primaryColorLight;

  static const Color startDefaultPageElementBackgroundColorGradient = secondaryLightColor;
  static const Color endDefaultPageElementBackgroundColorGradient = secondaryColor;

  static const TextStyle defaultBottomTabItemTextStyle = TextStyle(
    color: defaultTextColor,
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: Dimensions.mediumFontSize,
    color: defaultTextColor,
  );

  static const TextStyle subTitleTextStyle = TextStyle(
    fontSize: Dimensions.standardFontSize,
    color: secondaryTextColor,
  );

  static const TextStyle sectionHeaderTextStyle = TextStyle(
    fontSize: Dimensions.extraSmallFontSize,
    color: secondaryTextColor,
  );

  static const BoxShadow defaultBoxShadow = BoxShadow(
    color: AppTheme.shadowColor,
    blurRadius: Styles.defaultShadowRadius,
    offset: Styles.defaultShadowOffset,
  );

  static const BorderRadius defaultBoxRadius = BorderRadius.all(
    Radius.circular(
      Styles.boardGameTileImageCircularRadius,
    ),
  );

  static const TextStyle defaultTextFieldStyle = TextStyle(
    fontSize: Dimensions.standardFontSize,
  );

  static const InputDecoration defaultTextFieldInputDecoration = InputDecoration(
    focusColor: AppTheme.accentColor,
    hintStyle: TextStyle(
      color: secondaryTextColor,
      fontSize: Dimensions.standardFontSize,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.primaryColor,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.accentColor,
      ),
    ),
  );

  // MK Material fonts https://miro.medium.com/max/1400/1*Jlt_w6Bs7KAae42rYkFlwg.png
  static ThemeData get theme {
    final originalTextTheme = GoogleFonts.latoTextTheme();
    final originalInputDecorationTheme = ThemeData.light().inputDecorationTheme;
    final originalBodyText1 = originalTextTheme.bodyText1;
    final originalBodyText2 = originalTextTheme.bodyText2;
    final originalHeadline5 = originalTextTheme.headline5;
    final originalHeadline4 = originalTextTheme.headline4;
    final originalHeadline3 = originalTextTheme.headline3;
    final originalHeadline2 = originalTextTheme.headline2;
    final originalHeadline1 = originalTextTheme.headline1;
    final originalSubtitle1 = originalTextTheme.subtitle1;
    final originalSubtitle2 = originalTextTheme.subtitle2;
    final originalBottomNavigationBarTheme = ThemeData.light().bottomNavigationBarTheme;

    return ThemeData.light().copyWith(
      chipTheme: ThemeData.light().chipTheme.copyWith(
            elevation: Dimensions.defaultElevation,
          ),
      cardColor: primaryColorLight, // LicensePage after loading
      scaffoldBackgroundColor: primaryColorLight, // LicensePage when loading
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      accentColor: accentColor,
      buttonColor: accentColor,
      textSelectionColor: Colors.cyan[100],
      backgroundColor: Colors.grey[800],
      canvasColor: primaryColorLight,
      textTheme: originalTextTheme.copyWith(
        bodyText1: originalBodyText1.copyWith(
          decorationColor: Colors.transparent,
          color: defaultTextColor,
          fontSize: Dimensions.mediumFontSize,
        ),
        bodyText2: originalBodyText2.copyWith(
          decorationColor: Colors.transparent,
          color: defaultTextColor,
          fontSize: Dimensions.standardFontSize,
        ),
        headline5: originalHeadline5.copyWith(
          color: defaultTextColor,
        ),
        headline4: originalHeadline4.copyWith(
          fontSize: Dimensions.standardFontSize,
          color: defaultTextColor,
        ),
        headline3: originalHeadline3.copyWith(
          fontSize: Dimensions.mediumFontSize,
          color: defaultTextColor,
        ),
        headline2: originalHeadline2.copyWith(
          fontSize: Dimensions.largeFontSize,
          color: defaultTextColor,
        ),
        headline1: originalHeadline1.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: defaultTextColor,
        ),
        subtitle1: originalSubtitle1.copyWith(
          fontSize: Dimensions.smallFontSize,
          color: secondaryTextColor,
        ),
        subtitle2: originalSubtitle2.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: secondaryTextColor,
        ),
      ),
      inputDecorationTheme: originalInputDecorationTheme.copyWith(
        labelStyle: const TextStyle(
          color: defaultTextColor,
        ),
      ),
      bottomNavigationBarTheme: originalBottomNavigationBarTheme.copyWith(
        unselectedLabelStyle: const TextStyle(color: defaultTextColor),
        selectedLabelStyle: const TextStyle(
          color: defaultTextColor,
        ),
      ),
    );
  }
}
