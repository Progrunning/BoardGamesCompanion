import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimensions.dart';
import 'styles.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color blueColor = Colors.blue;
  static const Color redColor = Colors.red;

  static const Color primaryColorLight = Color(0xFF5B217F);
  static const Color primaryColor = Color(0xFF2D103F);

  static const Color accentColor = Color(0xFFFF9800);

  static const Color secondaryColor = Color(0xFF010055);
  static const Color secondaryLightColor = Color(0xFF2747A5);

  static const Color shadowColor = blackColor;

  static const Color defaultTextColor = whiteColor;
  static const Color invertedTextColor = blackColor;

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
    color: defaultTextColor,
  );

  // MK Material fonts https://miro.medium.com/max/1400/1*Jlt_w6Bs7KAae42rYkFlwg.png
  static ThemeData get theme {
    final originalTextTheme = GoogleFonts.latoTextTheme();
    const originalColorScheme = ColorScheme.light();
    final originalInputDecorationTheme = ThemeData.light().inputDecorationTheme;
    final originalBodyText1 = originalTextTheme.bodyText1;
    final originalBodyText2 = originalTextTheme.bodyText2;
    final originalHeadline5 = originalTextTheme.headline5;
    final originalHeadline2 = originalTextTheme.headline2;
    final originalHeadline1 = originalTextTheme.headline1;
    final originalSubtitle2 = originalTextTheme.subtitle2;
    final originalBottomNavigationBarTheme = ThemeData.light().bottomNavigationBarTheme;
    final originaltimePickerTheme = ThemeData.light().timePickerTheme;

    final subtitle1TextStyle = originalTextTheme.subtitle1.copyWith(
      fontSize: Dimensions.smallFontSize,
      color: secondaryTextColor,
    );

    final headline6TextStyle = originalTextTheme.headline6.copyWith(
      color: defaultTextColor,
    );

    final headline3TextStyle = originalTextTheme.headline3.copyWith(
      fontSize: Dimensions.mediumFontSize,
      fontWeight: FontWeight.bold,
      color: defaultTextColor,
    );

    final headline4TextStyle = originalTextTheme.headline4.copyWith(
      fontSize: Dimensions.standardFontSize,
      color: defaultTextColor,
    );

    return ThemeData.light().copyWith(
      cardColor: primaryColorLight, // LicensePage after loading
      scaffoldBackgroundColor: primaryColorLight, // LicensePage when loading
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      accentColor: accentColor,
      buttonColor: accentColor,
      textSelectionColor: Colors.cyan[100],
      backgroundColor: Colors.grey[800],
      highlightColor: accentColor,
      dialogBackgroundColor: primaryColorLight,
      dialogTheme: ThemeData.light().dialogTheme.copyWith(
            backgroundColor: primaryColorLight,
            titleTextStyle: headline3TextStyle,
            contentTextStyle: headline4TextStyle.copyWith(
              color: defaultTextColor,
            ),
          ),
      colorScheme: originalColorScheme.copyWith(
        primary: primaryColor,
        onPrimary: defaultTextColor,
        secondary: secondaryColor,
        onSecondary: defaultTextColor,
        surface: primaryColorLight,
        onSurface: defaultTextColor,
        background: primaryColorLight,
        onBackground: defaultTextColor,
      ),
      timePickerTheme: originaltimePickerTheme.copyWith(
        backgroundColor: primaryColorLight,
        dialBackgroundColor: accentColor,
        dialTextColor: invertedTextColor,
        dialHandColor: whiteColor,
        helpTextStyle: const TextStyle(
          color: defaultTextColor,
        ),
      ),
      canvasColor: primaryColorLight,
      buttonTheme: ThemeData.light().buttonTheme.copyWith(
            buttonColor: accentColor,
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: accentColor,
        ),
      ),
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
        headline6: headline6TextStyle,
        headline5: originalHeadline5.copyWith(
          color: defaultTextColor,
        ),
        headline4: headline4TextStyle,
        headline3: headline3TextStyle,
        headline2: originalHeadline2.copyWith(
          fontSize: Dimensions.largeFontSize,
          fontWeight: FontWeight.bold,
          color: defaultTextColor,
        ),
        headline1: originalHeadline1.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: defaultTextColor,
        ),
        subtitle1: subtitle1TextStyle,
        subtitle2: originalSubtitle2.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: secondaryTextColor,
        ),
      ),
      inputDecorationTheme: originalInputDecorationTheme.copyWith(
        focusColor: accentColor,
        hintStyle: const TextStyle(
          color: secondaryTextColor,
          fontSize: Dimensions.standardFontSize,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.accentColor,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor,
        selectionHandleColor: accentColor,
      ),
      useTextSelectionTheme: true,
      bottomNavigationBarTheme: originalBottomNavigationBarTheme.copyWith(
        unselectedLabelStyle: const TextStyle(color: defaultTextColor),
        selectedLabelStyle: const TextStyle(
          color: defaultTextColor,
        ),
      ),
      chipTheme: ThemeData.light().chipTheme.copyWith(
            elevation: Dimensions.defaultElevation,
          ),
      snackBarTheme: ThemeData.light().snackBarTheme.copyWith(
        backgroundColor: secondaryLightColor,
        actionTextColor: accentColor
      ),
    );
  }
}
