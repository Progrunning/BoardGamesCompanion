import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem(String title, IconData icon)
      : super(
          title: Text(
            title,
            style: AppTheme.defaultBottomTabItemTextStyle,
          ),
          icon: Icon(
            icon,
            color: AppTheme.deselectedBottomTabIconColor,
          ),
          activeIcon: Icon(
            icon,
            color: AppTheme.accentColor,
          ),
        );
}
