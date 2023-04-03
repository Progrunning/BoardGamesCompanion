import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.padding = const EdgeInsets.only(left: Dimensions.standardSpacing),
    Key? key,
  }) : super(key: key);

  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: AppTheme.theme.textTheme.displayMedium,
      ),
    );
  }
}
