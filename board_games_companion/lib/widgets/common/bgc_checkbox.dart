import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class BgcCheckbox extends StatelessWidget {
  const BgcCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  static const double _checkboxSize = 34;

  final bool isChecked;
  final Function(bool? isChecked) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _checkboxSize,
      width: _checkboxSize,
      child: Checkbox(
        checkColor: AppColors.accentColor,
        activeColor: AppColors.primaryColor.withOpacity(0.7),
        value: isChecked,
        onChanged: (bool? isChecked) => onChanged(isChecked),
      ),
    );
  }
}
