import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';

class RankRibbon extends StatelessWidget {
  const RankRibbon({
    required num rank,
    Key? key,
  })  : _rank = rank,
        super(key: key);

  final num _rank;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.asset(
          'assets/icons/rank_ribbon.svg',
          height: 34,
          width: 26,
          color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '#${_rank.toString()}',
              style: const TextStyle(
                color: AppColors.defaultTextColor,
                fontSize: Dimensions.smallFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
