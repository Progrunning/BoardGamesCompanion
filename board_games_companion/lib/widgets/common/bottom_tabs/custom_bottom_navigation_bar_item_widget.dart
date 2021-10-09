import 'package:flutter/material.dart';

import '../../../common/app_theme.dart';

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem(String title, IconData icon)
      : super(
          label: title,
          icon: Icon(
            icon,
            color: AppTheme.deselectedTabIconColor,
          ),
          activeIcon: Icon(
            icon,
            color: AppTheme.accentColor,
          ),
        );
}
