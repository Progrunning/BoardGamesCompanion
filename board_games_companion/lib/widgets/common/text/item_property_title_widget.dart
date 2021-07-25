import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class ItemPropertyTitle extends StatelessWidget {
  const ItemPropertyTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: AppTheme.sectionHeaderTextStyle,
    );
  }
}
