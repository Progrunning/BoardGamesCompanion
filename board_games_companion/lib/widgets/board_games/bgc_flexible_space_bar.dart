import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import 'board_game_image.dart';

class BgcFlexibleSpaceBar extends StatelessWidget {
  const BgcFlexibleSpaceBar({
    required this.boardGameName,
    required this.boardGameImageUrl,
    this.id,
    super.key,
  });

  final String boardGameName;
  final String? boardGameImageUrl;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      titlePadding: const EdgeInsets.only(
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
        bottom: Dimensions.doubleStandardSpacing,
      ),
      centerTitle: true,
      title: Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
          borderRadius: const BorderRadius.all(
            Radius.circular(AppStyles.defaultCornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
          child: Text(
            boardGameName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.defaultTextColor,
              fontSize: Dimensions.largeFontSize,
            ),
          ),
        ),
      ),
      background: BoardGameImage(
        id: id,
        url: boardGameImageUrl,
        minImageHeight: Constants.boardGameDetailsImageHeight,
      ),
    );
  }
}
