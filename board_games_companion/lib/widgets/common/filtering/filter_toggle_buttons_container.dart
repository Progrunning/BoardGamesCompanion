import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/dimensions.dart';

class FilterToggleButtonsContainer extends StatelessWidget {
  const FilterToggleButtonsContainer({
    super.key,
    required this.height,
    required this.child,
    this.backgroundColor = AppColors.primaryColor,
  });

  final double height;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: ElevatedContainer(
          elevation: Dimensions.defaultElevation,
          child: Container(
            color: backgroundColor,
            child: child,
          ),
        ),
      );
}
