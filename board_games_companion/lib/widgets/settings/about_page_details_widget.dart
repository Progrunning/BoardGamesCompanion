import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/pages/about.dart';
import 'package:board_games_companion/utilities/navigator_transitions.dart';
import 'package:board_games_companion/widgets/about/detail_item_widget.dart';
import 'package:board_games_companion/widgets/common/rippler_effect.dart';
import 'package:flutter/material.dart';

class AboutPageDetails extends StatelessWidget {
  const AboutPageDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      child: Stack(
        children: <Widget>[
          DetailsItem(
            title: 'About',
            subtitle: 'App information',
            onTap: () async {
              await Navigator.push(
                context,
                NavigatorTransitions.fadeThrough(
                  (_, __, ___) {
                    return AboutPage();
                  },
                ),
              );
            },
          ),
          Positioned.fill(
            right: Dimensions.standardSpacing,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.navigate_next,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
