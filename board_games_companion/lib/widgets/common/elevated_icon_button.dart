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
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return color.withOpacity(0.5);
            }

            return color;
          },
        ),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.darkGreyColor.withOpacity(0.4);
            }

            return AppColors.defaultTextColor;
          },
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: AppColors.defaultTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
