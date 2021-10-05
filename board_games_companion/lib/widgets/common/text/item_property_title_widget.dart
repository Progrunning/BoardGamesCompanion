import 'package:flutter/material.dart';

import '../../../common/app_theme.dart';

class ItemPropertyTitle extends StatelessWidget {
  const ItemPropertyTitle(
    this.title, {
    this.color = AppTheme.secondaryTextColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.sectionHeaderTextStyle.copyWith(
        color: color,
      ),
    );
  }
}
