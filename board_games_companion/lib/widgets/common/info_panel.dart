import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({
    required this.text,
    this.icon = const Icon(Icons.info_outlined, size: Dimensions.smallButtonIconSize),
    super.key,
  });

  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: Dimensions.standardSpacing),
        Expanded(
          child: Text(
            text,
            style: AppTheme.theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
