import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class ItemPropertyTitle extends StatelessWidget {
  final String title;

  const ItemPropertyTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: AppTheme.sectionHeaderTextStyle,
    );
  }
}
