import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/dimensions.dart';

class CollectionToggleButton extends StatelessWidget {
  const CollectionToggleButton({
    required this.icon,
    required this.title,
    required this.isSelected,
    super.key,
  });

  final IconData icon;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
        vertical: Dimensions.halfStandardSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.whiteColor : AppColors.deselectedTabIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
