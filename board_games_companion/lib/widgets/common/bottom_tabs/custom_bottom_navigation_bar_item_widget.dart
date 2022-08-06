import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem(String title, IconData icon)
      : super(
          label: title,
          icon: Icon(
            icon,
            color: AppColors.deselectedTabIconColor,
          ),
          activeIcon: Icon(
            icon,
            color: AppColors.accentColor,
          ),
        );
}
