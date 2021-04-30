import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../pages/about_page.dart';
import '../../utilities/navigator_transitions.dart';
import '../about/detail_item_widget.dart';
import '../common/rippler_effect.dart';

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
