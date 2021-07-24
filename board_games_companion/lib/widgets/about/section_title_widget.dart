import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    @required this.title,
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.standardSpacing,
        ),
        child: Text(
          title,
          style: AppTheme.theme.textTheme.headline2,
        ),
      ),
    );
  }
}
