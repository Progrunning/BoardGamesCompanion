import 'package:flutter/material.dart';

import '../../common/app_theme.dart';

class IconAndElevatedButton extends StatelessWidget {
  const IconAndElevatedButton({
    required this.icon,
    this.title,
    this.color = AppTheme.accentColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

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
              return AppTheme.darkGreyColor.withOpacity(0.4);
            }

            return AppTheme.defaultTextColor;
          },
        ),
        textStyle: MaterialStateProperty.all(
            const TextStyle(color: AppTheme.defaultTextColor, fontWeight: FontWeight.bold)),
      ),
      onPressed: onPressed,
    );
  }
}
