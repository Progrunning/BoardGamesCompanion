import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/services/auth_service.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/settings/about_page_details_widget.dart';
import 'package:board_games_companion/widgets/settings/user_details_widget.dart';
import 'package:board_games_companion/widgets/settings/version_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO MK Make it nicer and update the button UI
    final AuthService authService = Provider.of<AuthService>(
      context,
      listen: false,
    );
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
                  AboutPageDetails(),
                  IconAndTextButton(
                    icon: Icons.local_gas_station,
                    onPressed: () async {
                      await authService.signIn();
                    },
                  )
                  // FlatButton(
                  //   onPressed: () {  },
                  //   child: Text('Sign in'),
                  // ),
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
