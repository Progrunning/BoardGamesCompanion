import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../common/app_theme.dart';
import '../common/constants.dart';
import '../common/dimensions.dart';
import '../common/strings.dart';
import '../utilities/launcher_helper.dart';
import '../widgets/about/detail_item_widget.dart';
import '../widgets/about/section_text_widget.dart';
import '../widgets/about/section_title_widget.dart';
import '../widgets/common/page_container_widget.dart';
import 'base_page_state.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends BasePageState<AboutPage> {
  static const String privactyPolicyUrl =
      'https://progrunning.net/board-games-companion-privacy-policy/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SafeArea(
        child: PageContainer(
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
                      children: const <Widget>[
                        SectionTitle(
                          title: 'AUTHOR',
                        ),
                        DetailsItem(
                          title: 'Mikolaj Kieres',
                          subtitle: Constants.FeedbackEmailAddress,
                          uri: 'mailto:${Constants.FeedbackEmailAddress}?subject=BGC%20Feedback',
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
                          subtitle: 'instagram.com/adamkiewicz_art',
                          uri: 'https://www.instagram.com/adamkiewicz_art',
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
                              "The board games data shown in the app is a courtesy of the publicly available BoardGameGeek's XML API.",
                        ),
                        SectionText(
                          text: 'See below links for more details:',
                        ),
                        DetailsItem(
                            title: 'BGG',
                            subtitle: 'boardgamegeek.com',
                            uri: Constants.BoardGameGeekBaseApiUrl),
                        DetailsItem(
                            title: 'XML API',
                            subtitle: 'boardgamegeek.com/wiki/page/BGG_XML_API2',
                            uri: 'https://boardgamegeek.com/wiki/page/BGG_XML_API2'),
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
                            title: 'Lato Font',
                            subtitle: 'Powered by Google Fonts',
                            uri: 'https://pub.dev/packages/google_fonts'),
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
                            subtitle: 'Provides the ability to create custom http adapters',
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
                            subtitle: 'Picking images and taking photos with camera',
                            uri: 'https://pub.dev/packages/image_picker'),
                        DetailsItem(
                            title: 'Image Picker',
                            subtitle: 'Picking images and taking photos with camera',
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
                            subtitle: "Launching Uri's",
                            uri: 'https://pub.dev/packages/url_launcher'),
                        Divider(
                          color: AppTheme.accentColor,
                        ),
                        SectionTitle(
                          title: 'LICENSES',
                        ),
                        _LicensePageDetailsItem(),
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
                      children: const <Widget>[
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
        ),
      ),
    );
  }
}

class _LicensePageDetailsItem extends StatelessWidget {
  const _LicensePageDetailsItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data is PackageInfo) {
          return Stack(
            children: <Widget>[
              DetailsItem(
                title: "Board Game Companion's licenses",
                subtitle: "App's components licenses",
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: Strings.AppTitle,
                    applicationIcon: Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.doubleStandardSpacing,
                      ),
                      child: Image.asset(
                        'assets/icons/logo_transparent.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    applicationVersion: (snapshot.data as PackageInfo).version,
                  );
                },
              ),
              const Positioned.fill(
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
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
