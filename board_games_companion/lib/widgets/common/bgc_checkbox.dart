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
          activeColor: AppColors.primaryColor.withOpacity(0.7),
          overlayColor: MaterialStateProperty.all(AppColors.accentColor.withOpacity(0.6)),
          side: MaterialStateBorderSide.resolveWith(
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
