import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_styles.dart';
import 'dimensions.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: Dimensions.largeFontSize,
    color: AppColors.defaultTextColor,
  );

  static const TextStyle subTitleTextStyle = TextStyle(
    fontSize: Dimensions.standardFontSize,
    color: AppColors.secondaryTextColor,
  );

  static const TextStyle sectionHeaderTextStyle = TextStyle(
    fontSize: Dimensions.extraSmallFontSize,
    color: AppColors.secondaryTextColor,
  );

  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(AppStyles.boardGameTileImageCircularRadius),
  );

  static const TextStyle defaultTextFieldStyle = TextStyle(
    fontSize: Dimensions.mediumFontSize,
    color: AppColors.defaultTextColor,
  );

  static const TextStyle defaultTextFieldLabelStyle = TextStyle(
    fontSize: Dimensions.standardFontSize,
    color: AppColors.secondaryTextColor,
  );

  // MK Material fonts https://miro.medium.com/max/1400/1*Jlt_w6Bs7KAae42rYkFlwg.png
  static ThemeData get theme {
    final originalTextTheme = GoogleFonts.latoTextTheme();
    const originalColorScheme = ColorScheme.light();
    final originalInputDecorationTheme = ThemeData.light().inputDecorationTheme;
    final originalBodyText1 = originalTextTheme.bodyText1!;
    final originalBodyText2 = originalTextTheme.bodyText2!;
    final originalHeadline5 = originalTextTheme.headline5!;
    final originalHeadline2 = originalTextTheme.headline2!;
    final originalSubtitle2 = originalTextTheme.subtitle2!;
    final originalBottomNavigationBarTheme = ThemeData.light().bottomNavigationBarTheme;
    final originaltimePickerTheme = ThemeData.light().timePickerTheme;

    final subtitle1TextStyle = originalTextTheme.subtitle1!.copyWith(
      fontSize: Dimensions.smallFontSize,
      color: AppColors.secondaryTextColor,
    );

    final headline6TextStyle = originalTextTheme.headline6!.copyWith(
      color: AppColors.defaultTextColor,
    );

    final headline2TextStyle = originalTextTheme.headline2!.copyWith(
      fontSize: Dimensions.largeFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final headline1TextStyle = originalTextTheme.headline1!.copyWith(
      fontSize: Dimensions.extraLargeFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final headline3TextStyle = originalTextTheme.headline3!.copyWith(
      fontSize: Dimensions.mediumFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final headline4TextStyle = originalTextTheme.headline4!.copyWith(
      fontSize: Dimensions.standardFontSize,
      color: AppColors.defaultTextColor,
    );

    return ThemeData.light().copyWith(
      cardColor: AppColors.primaryColorLight, // LicensePage after loading
      scaffoldBackgroundColor: AppColors.primaryColorLight, // LicensePage when loading
      primaryColor: AppColors.primaryColor,
      primaryColorLight: AppColors.primaryColorLight,
      backgroundColor: Colors.grey[800],
      highlightColor: AppColors.accentColor,
      dialogBackgroundColor: AppColors.primaryColorLight,
      dialogTheme: ThemeData.light().dialogTheme.copyWith(
            backgroundColor: AppColors.primaryColorLight,
            titleTextStyle: headline2TextStyle,
            contentTextStyle: headline3TextStyle.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
      colorScheme: originalColorScheme.copyWith(
        primary: AppColors.primaryColor,
        onPrimary: AppColors.defaultTextColor,
        secondary: AppColors.accentColor,
        onSecondary: AppColors.defaultTextColor,
        surface: AppColors.primaryColorLight,
        onSurface: AppColors.defaultTextColor,
        background: AppColors.primaryColorLight,
        onBackground: AppColors.defaultTextColor,
      ),
      timePickerTheme: originaltimePickerTheme.copyWith(
        backgroundColor: AppColors.primaryColorLight,
        dialBackgroundColor: AppColors.accentColor,
        dialTextColor: AppColors.invertedTextColor,
        dialHandColor: AppColors.whiteColor,
        helpTextStyle: const TextStyle(
          color: AppColors.defaultTextColor,
        ),
      ),
      canvasColor: AppColors.primaryColorLight,
      buttonTheme: ThemeData.light().buttonTheme.copyWith(
            buttonColor: AppColors.accentColor,
          ),
      toggleButtonsTheme: ThemeData.light().toggleButtonsTheme.copyWith(
            selectedColor: AppColors.accentColor,
            color: AppColors.deselectedTabIconColor,
            splashColor: AppColors.accentColor.withAlpha(AppStyles.opacity30Percent),
            fillColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            disabledBorderColor: Colors.transparent,
            borderColor: Colors.transparent,
            textStyle: TextStyle(
              fontSize: Dimensions.smallFontSize,
              color: MaterialStateColor.resolveWith(
                (states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.accentColor;
                  }

                  return AppColors.deselectedTabIconColor;
                },
              ),
            ),
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.accentColor),
      ),
      textTheme: originalTextTheme.copyWith(
        bodyText1: originalBodyText1.copyWith(
          decorationColor: Colors.transparent,
          color: AppColors.defaultTextColor,
          fontSize: Dimensions.mediumFontSize,
        ),
        bodyText2: originalBodyText2.copyWith(
          decorationColor: Colors.transparent,
          color: AppColors.defaultTextColor,
          fontSize: Dimensions.standardFontSize,
        ),
        headline6: headline6TextStyle,
        headline5: originalHeadline5.copyWith(
          color: AppColors.defaultTextColor,
        ),
        headline4: headline4TextStyle,
        headline3: headline3TextStyle,
        headline2: originalHeadline2.copyWith(
          fontSize: Dimensions.largeFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.defaultTextColor,
        ),
        headline1: headline1TextStyle,
        subtitle1: subtitle1TextStyle,
        subtitle2: originalSubtitle2.copyWith(
          fontSize: Dimensions.extraLargeFontSize,
          color: AppColors.secondaryTextColor,
        ),
      ),
      inputDecorationTheme: originalInputDecorationTheme.copyWith(
        focusColor: AppColors.accentColor,
        hintStyle: const TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: Dimensions.standardFontSize,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accentColor,
        selectionColor: AppColors.accentColor,
        selectionHandleColor: AppColors.accentColor,
      ),
      bottomNavigationBarTheme: originalBottomNavigationBarTheme.copyWith(
        unselectedLabelStyle: const TextStyle(color: AppColors.defaultTextColor),
        selectedLabelStyle: const TextStyle(color: AppColors.defaultTextColor),
      ),
      chipTheme: ThemeData.light().chipTheme.copyWith(
            elevation: Dimensions.defaultElevation,
          ),
      snackBarTheme: ThemeData.light().snackBarTheme.copyWith(
            backgroundColor: AppColors.primaryColorLight,
            actionTextColor: AppColors.accentColor,
          ),
      dividerTheme: ThemeData.light().dividerTheme.copyWith(
            color: AppColors.accentColor,
            space: 0.5,
            thickness: 0.5,
          ),
      iconTheme: ThemeData.light().iconTheme.copyWith(color: AppColors.accentColor),
    );
  }
}
