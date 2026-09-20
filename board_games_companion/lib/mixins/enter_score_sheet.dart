import 'dart:async';

import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';
import '../common/dimensions.dart';
import '../pages/enter_score/enter_score_sheet.dart';
import '../pages/enter_score/enter_score_view_model.dart';

mixin EnterScoreSheetMixin {
  Future<void> showEnterScoreSheet(BuildContext context, EnterScoreViewModel viewModel) async {
    await showModalBottomSheet<void>(
      context: context,
      routeSettings: const RouteSettings(name: EnterScoreSheet.pageRoute),
      backgroundColor: AppColors.primaryColor,
      elevation: Dimensions.defaultElevation,
      isScrollControlled: true,
      // A keypad sits at the very bottom of the screen and needs the gesture navigation inset.
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
          topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
        ),
      ),
      builder: (_) => EnterScoreSheet(viewModel: viewModel),
    );

    // Dismissal commits, by any route - Done, a swipe away or the system back gesture all land
    // here, so the score settles the same way whichever one the player used.
    viewModel.close();
  }
}
