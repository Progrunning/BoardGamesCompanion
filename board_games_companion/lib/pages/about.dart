import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:board_games_companion/widgets/about/detail_item_widget.dart';
import 'package:board_games_companion/widgets/about/section_text_widget.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: Dimensions.standardFontSize,
                    ),
                    SectionTitle(
                      title: 'AUTHOR',
                    ),
                    DetailsItem(
                      title: 'Mikolaj Kieres',
                      subtitle: feedbackEmailAddress,
                      uri:
                          'mailto:$feedbackEmailAddress?subject=BGC%20Feedback',
                      iconUri: 'assets/mikolaj_profile_picture.jpg',
                    ),
                    Divider(
                      color: AppTheme.accentColor,
                    ),
                    SectionTitle(
                      title: 'DESIGN & ART',
                    ),
                    DetailsItem(
                      title: 'Alicja Adamkiewicz',
                      subtitle: 'adamkiewiczart.com',
                      uri: 'http://adamkiewiczart.com',
                      iconUri: 'assets/adamkiewiczart_logo.png',
                    ),
                    Divider(
                      color: AppTheme.accentColor,
                    ),
                    SectionTitle(
                      title: 'CONTENT & DATA',
                    ),
                    SectionText(
                      text:
                          'The board games data shown in the app is a courtesy of the publicly available BoardGameGeek\'s XML API.',
                    ),
                    SectionText(
                      text: 'See below links for more details:',
                    ),
                    DetailsItem(
                        title: 'BGG',
                        subtitle: 'boardgamegeek.com',
                        uri: 'https://boardgamegeek.com'),
                    DetailsItem(
                        title: 'XML API',
                        subtitle: 'boardgamegeek.com/wiki/page/BGG_XML_API2',
                        uri:
                            'https://boardgamegeek.com/wiki/page/BGG_XML_API2'),
                    DetailsItem(
                        title: 'Terms of Service',
                        subtitle: 'boardgamegeek.com/terms',
                        uri: 'https://www.boardgamegeek.com/terms'),
                    Divider(
                      color: AppTheme.accentColor,
                    ),
                    SectionTitle(
                      title: 'PLUGINS & LIBRARIES',
                    ),
                    SectionText(
                      text:
                          'The below is a list of the plugins and libraries that helped in building this app:',
                    ),
                    DetailsItem(
                        title: 'Logging',
                        subtitle: 'Handles in app logs',
                        uri: 'https://pub.dev/packages/logging'),
                    DetailsItem(
                        title: 'Dio Http Cache',
                        subtitle: 'SQLite like cache of http responses',
                        uri: 'https://pub.dev/packages/dio_http_cache'),
                    DetailsItem(
                        title: 'Dio Http2 Adapter',
                        subtitle:
                            'Provides the ability to create custom http adapters',
                        uri: 'https://pub.dev/packages/dio_http2_adapter'),
                    DetailsItem(
                        title: 'Cached Network Image',
                        subtitle: 'Caching network images',
                        uri: 'https://pub.dev/packages/cached_network_image'),
                    DetailsItem(
                        title: 'Firebase Crashlytics',
                        subtitle: 'Captures app crash analytics',
                        uri: 'https://pub.dev/packages/firebase_crashlytics'),
                    DetailsItem(
                        title: 'Hive',
                        subtitle: 'NoSQL Database',
                        uri: 'https://pub.dev/packages/hive'),
                    DetailsItem(
                        title: 'Path Provider',
                        subtitle: 'Helps with filesystem paths',
                        uri: 'https://pub.dev/packages/path_provider'),
                    DetailsItem(
                        title: 'Polygon Clipper',
                        subtitle: 'Draws polygon shapes',
                        uri: 'https://pub.dev/packages/polygon_clipper'),
                    DetailsItem(
                        title: 'Carousel Slider',
                        subtitle: 'Helps with carousels',
                        uri: 'https://pub.dev/packages/carousel_slider'),
                    DetailsItem(
                        title: 'Image Picker',
                        subtitle:
                            'Picking images and taking photos with camera',
                        uri: 'https://pub.dev/packages/image_picker'),
                    DetailsItem(
                        title: 'Image Picker',
                        subtitle:
                            'Picking images and taking photos with camera',
                        uri: 'https://pub.dev/packages/image_picker'),
                    DetailsItem(
                        title: 'XML',
                        subtitle: 'Parsing XML API responses',
                        uri: 'https://pub.dev/packages/xml'),
                    DetailsItem(
                        title: 'Provider',
                        subtitle: 'DI & state management',
                        uri: 'https://pub.dev/packages/provider'),
                    DetailsItem(
                        title: 'Animations',
                        subtitle: 'Navigation animations',
                        uri: 'https://pub.dev/packages/animations'),
                    DetailsItem(
                        title: 'Url Launcher',
                        subtitle: 'Launching Uri\'s',
                        uri: 'https://pub.dev/packages/url_launcher'),
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
