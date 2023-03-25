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
    final originalBodyLarge = originalTextTheme.bodyLarge!;
    final originalBodyMedium = originalTextTheme.bodyMedium!;
    final originalHeadlineSmall = originalTextTheme.headlineSmall!;
    final originalHeadlineMedium = originalTextTheme.displayMedium!;
    final originalSubtitleSmall = originalTextTheme.titleSmall!;
    final originalBottomNavigationBarTheme = ThemeData.light().bottomNavigationBarTheme;
    final originaltimePickerTheme = ThemeData.light().timePickerTheme;

    final subtitleMediumTextStyle = originalTextTheme.titleMedium!.copyWith(
      fontSize: Dimensions.smallFontSize,
      color: AppColors.secondaryTextColor,
    );

    final titleLargeTextStyle = originalTextTheme.titleLarge!.copyWith(
      color: AppColors.defaultTextColor,
    );

    final displayMediumTextStyle = originalTextTheme.displayMedium!.copyWith(
      fontSize: Dimensions.largeFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final displayLargeTextStyle = originalTextTheme.displayLarge!.copyWith(
      fontSize: Dimensions.extraLargeFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final displaySmallTextStyle = originalTextTheme.displaySmall!.copyWith(
      fontSize: Dimensions.mediumFontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.defaultTextColor,
    );

    final headlineMediumTextStyle = originalTextTheme.headlineMedium!.copyWith(
      fontSize: Dimensions.standardFontSize,
      color: AppColors.defaultTextColor,
    );

    return ThemeData.light().copyWith(
      cardColor: AppColors.primaryColorLight, // LicensePage after loading
      scaffoldBackgroundColor: AppColors.primaryColorLight, // LicensePage when loading
      primaryColor: AppColors.primaryColor,
      primaryColorLight: AppColors.primaryColorLight,
      highlightColor: AppColors.accentColor,
      dialogBackgroundColor: AppColors.primaryColorLight,
      dialogTheme: ThemeData.light().dialogTheme.copyWith(
            backgroundColor: AppColors.primaryColorLight,
            titleTextStyle: displayMediumTextStyle,
            contentTextStyle: displaySmallTextStyle.copyWith(
              fontWeight: FontWeight.normal,
            ),
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
      sliderTheme: ThemeData.light().sliderTheme.copyWith(
            trackHeight: 8,
            trackShape: const RoundedRectSliderTrackShape(),
            inactiveTrackColor: AppColors.primaryColorLight.withAlpha(AppStyles.opacity30Percent),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
            tickMarkShape: const RoundSliderTickMarkShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: const TextStyle(fontSize: Dimensions.smallFontSize),
            showValueIndicator: ShowValueIndicator.always,
            rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
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
        bodyLarge: originalBodyLarge.copyWith(
          decorationColor: Colors.transparent,
          color: AppColors.defaultTextColor,
          fontSize: Dimensions.mediumFontSize,
        ),
        bodyMedium: originalBodyMedium.copyWith(
          decorationColor: Colors.transparent,
          color: AppColors.defaultTextColor,
          fontSize: Dimensions.standardFontSize,
        ),
        titleLarge: titleLargeTextStyle,
        headlineSmall: originalHeadlineSmall.copyWith(
          color: AppColors.defaultTextColor,
        ),
        headlineMedium: headlineMediumTextStyle,
        displaySmall: displaySmallTextStyle,
        displayMedium: originalHeadlineMedium.copyWith(
          fontSize: Dimensions.largeFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.defaultTextColor,
        ),
        displayLarge: displayLargeTextStyle,
        titleMedium: subtitleMediumTextStyle,
        titleSmall: originalSubtitleSmall.copyWith(
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
      colorScheme: originalColorScheme
          .copyWith(
            primary: AppColors.primaryColor,
            onPrimary: AppColors.defaultTextColor,
            secondary: AppColors.accentColor,
            onSecondary: AppColors.defaultTextColor,
            surface: AppColors.primaryColorLight,
            onSurface: AppColors.defaultTextColor,
            background: AppColors.primaryColorLight,
            onBackground: AppColors.defaultTextColor,
          )
          .copyWith(background: Colors.grey[800]),
    );
  }
}
