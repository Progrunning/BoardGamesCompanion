import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/widgets/settings/about_page_details_widget.dart';
import 'package:board_games_companion/widgets/settings/user_details_widget.dart';
import 'package:board_games_companion/widgets/settings/user_profile_widget.dart';
import 'package:board_games_companion/widgets/settings/version_number_widget.dart';
import 'package:flutter/material.dart';

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
                    height: Dimensions.standardSpacing,
                  ),
                  UserProfile(),
                  Divider(
                    color: AppTheme.accentColor,
                  ),
                  UserDetails(),
                  Divider(
                    color: AppTheme.accentColor,
                  ),
                  AboutPageDetails(),
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
