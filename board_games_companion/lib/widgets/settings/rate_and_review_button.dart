import 'package:board_games_companion/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../about/detail_item_widget.dart';
import '../common/rippler_effect.dart';

class RateAndReviewButton extends StatelessWidget {
  const RateAndReviewButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      child: Stack(
        children: <Widget>[
          DetailsItem(
            title: 'Rate & Review',
            subtitle: 'Store listing',
            onTap: () async {
              await InAppReview.instance.openStoreListing(
                appStoreId: Constants.AppleAppId,
              );
            },
          ),
          Positioned.fill(
            right: Dimensions.standardSpacing,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.star,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
