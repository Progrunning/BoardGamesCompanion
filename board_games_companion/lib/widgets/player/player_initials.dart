import 'package:flutter/material.dart';

import '../../common/app_theme.dart';

class PlayerInitials extends StatelessWidget {
  const PlayerInitials({
    super.key,
    required this.initials,
  });

  final String initials;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final smallestConstraint = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        return Center(
          child: Text(
            initials,
            style: AppTheme.theme.textTheme.displayLarge?.copyWith(
              fontSize: smallestConstraint / 4,
            ),
          ),
        );
      },
    );
  }
}
