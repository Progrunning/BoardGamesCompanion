import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class BgcCheckbox extends StatelessWidget {
  const BgcCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.borderColor = AppColors.primaryColorLight,
  });

  static const double _checkboxSize = 34;

  final bool isChecked;
  final Function(bool? isChecked) onChanged;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _checkboxSize,
      width: _checkboxSize,
      child: Material(
        color: Colors.transparent,
        child: Checkbox(
          checkColor: AppColors.accentColor,
          activeColor: AppColors.primaryColor.withValues(alpha: .7),
          overlayColor: WidgetStateProperty.all(AppColors.accentColor.withValues(alpha: .6)),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: 2,
              color: borderColor,
            ),
          ),
          value: isChecked,
          onChanged: (bool? isChecked) => onChanged(isChecked),
        ),
      ),
    );
  }
}
