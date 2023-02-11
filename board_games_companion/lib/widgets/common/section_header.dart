import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.primaryTitle,
    this.secondaryTitle,
    double height = Dimensions.sectionHeaderHeight,
  })  : _height = height,
        super(key: key);

  final double _height;
  final String primaryTitle;
  final String? secondaryTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Dimensions.defaultElevation,
      color: AppColors.primaryColor,
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(primaryTitle, style: AppTheme.titleTextStyle, overflow: TextOverflow.ellipsis),
              if (secondaryTitle.isNotNullOrBlank) ...[
                const Expanded(child: SizedBox.shrink()),
                Text(
                  secondaryTitle!,
                  style: AppTheme.titleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
