import 'package:flutter/material.dart';

import '../common/dimensions.dart';
import '../widgets/settings/rate_and_review_button.dart';
import '../widgets/settings/about_page_details_widget.dart';
import '../widgets/settings/user_details_widget.dart';
import '../widgets/settings/version_number_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: Dimensions.standardFontSize,
                  ),
                  UserDetails(),
                  RateAndReviewButton(),
                  AboutPageDetails()
                ],
              ),
            ),
          ),
          VersionNumber(),
        ],
      ),
    );
  }
}
