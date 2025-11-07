import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class ElevatedIconButton extends StatelessWidget {
  const ElevatedIconButton({
    required this.icon,
    this.title,
    this.color = AppColors.accentColor,
    required this.onPressed,
    super.key,
  });

  static const double rippleEffectOpacityFactor = 0.7;

  final GestureTapCallback? onPressed;

  final Widget icon;
  final String? title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      label: title?.isNotEmpty ?? false ? Text(title!) : const SizedBox.shrink(),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return color.withValues(alpha: .5);
            }

            return color;
          },
        ),
        shape: WidgetStateProperty.all(const StadiumBorder()),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.darkGreyColor.withValues(alpha: .4);
            }

            return AppColors.defaultTextColor;
          },
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: AppColors.defaultTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
