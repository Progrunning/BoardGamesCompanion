import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';

class PlayerAvatarSubtitle extends StatelessWidget {
  const PlayerAvatarSubtitle({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Dimensions.halfStandardSpacing,
          left: Dimensions.halfStandardSpacing,
          right: Dimensions.halfStandardSpacing,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(AppStyles.defaultCornerRadius)),
            color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Text(
              player.name ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.defaultTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
