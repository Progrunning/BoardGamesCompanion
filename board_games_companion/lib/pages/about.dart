import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:board_games_companion/widgets/about/detail_item_widget.dart';
import 'package:board_games_companion/widgets/about/section_title_widget.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  static const String privactyPolicyUrl =
      'https://progrunning.net/board-games-companion-privacy-policy/';
  static const String feedbackEmailAddress = 'feedback@progrunning.net';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.standardSpacing,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.standardFontSize,
                    ),
                    SectionTitle(
                      title: 'AUTHOR',
                    ),
                    SizedBox(
                      height: Dimensions.halfStandardSpacing,
                    ),
                    DetailsItem(
                      title: 'Mikolaj Kieres',
                      subtitle: feedbackEmailAddress,
                      uri:
                          'mailto:$feedbackEmailAddress?subject=BGC%20Feedback',
                      iconUri: 'assets/mikolaj_profile_picture.jpg',
                    ),
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    Divider(
                      color: AppTheme.accentColor,
                    ),
                    SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    SectionTitle(
                      title: 'DESIGN & ART',
                    ),
                    SizedBox(
                      height: Dimensions.halfStandardSpacing,
                    ),
                    DetailsItem(
                      title: 'Alicja Adamkiewicz',
                      subtitle: 'adamkiewiczart.com',
                      uri: 'http://adamkiewiczart.com',
                      iconUri: 'assets/adamkiewiczart_logo.png',
                    ),
                    SizedBox(
                      height: Dimensions.halfStandardSpacing,
                    ),
                    Divider(
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppTheme.accentColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.doubleStandardSpacing,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                await LauncherHelper.launchUri(
                  context,
                  privactyPolicyUrl,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
