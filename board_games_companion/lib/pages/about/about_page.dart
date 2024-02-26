import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/about/detail_item.dart';
import '../../widgets/about/section_text.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../base_page_state.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const String pageRoute = '/about';

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends BasePageState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.aboutPageTitle, style: AppTheme.titleTextStyle),
      ),
      body: SafeArea(
        child: Theme(
          data: AppTheme.theme.copyWith(
            dividerTheme: AppTheme.theme.dividerTheme.copyWith(
              space: Dimensions.doubleStandardSpacing,
            ),
          ),
          child: PageContainer(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPageAuthorSectionTitle,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: DetailsItem(
                          title: 'Mikolaj Kieres',
                          subtitle: Constants.feedbackEmailAddress,
                          uri: 'mailto:${Constants.feedbackEmailAddress}?subject=BGC%20Feedback',
                          assetIconUri: 'assets/mikolaj_profile_picture.jpg',
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPageDesignAndArtSectionTitle,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: DetailsItem(
                          title: 'Alicja Adamkiewicz',
                          subtitle: 'instagram.com/adamkiewicz_art',
                          uri: 'https://www.instagram.com/adamkiewicz_art',
                          assetIconUri: 'assets/adamkiewiczart_logo.png',
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPageCommunityTitle,
                        ),
                      ),
                      const _CommunitySection(),
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPageContentAndDataSectionTitle,
                        ),
                      ),
                      const _ContentAndDataSection(),
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPagePluginsAndLibrariesSectionTitle,
                        ),
                      ),
                      const _PluginsAndLibrariesSection(),
                      SliverPersistentHeader(
                        delegate: BgcSliverTitleHeaderDelegate.title(
                          primaryTitle: AppText.aboutPageLicensesSectionTitle,
                        ),
                      ),
                      const _LicensePageDetailsItem(),
                    ],
                  ),
                ),
                const _PrivacyPolicyFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  static const String discordInviteUrl = 'https://discord.gg/t9dTVXxnvC';
  static const String discordLogoUri = 'assets/discord-logo-blue.svg';

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          const SectionText(text: AppText.aboutPageCommunitySubtitle),
          const SectionText(text: AppText.aboutPageCommunityJoinDiscord),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => LauncherHelper.launchUri(
                context,
                discordInviteUrl,
                launchMode: LaunchMode.externalApplication,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: SvgPicture.asset(
                  discordLogoUri,
                  height: Dimensions.detailsItemHeight,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentAndDataSection extends StatelessWidget {
  const _ContentAndDataSection();

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          SectionText(text: AppText.aboutPageContentAndDataBggXmlApiTitle),
          SectionText(text: AppText.aboutPageContentAndDataBggXmlApiSubtitle),
          DetailsItem(
              title: 'BGG', subtitle: 'boardgamegeek.com', uri: Constants.boardGameGeekBaseApiUrl),
          DetailsItem(
              title: 'XML API',
              subtitle: 'boardgamegeek.com/wiki/page/BGG_XML_API2',
              uri: 'https://boardgamegeek.com/wiki/page/BGG_XML_API2'),
          DetailsItem(
              title: 'Terms of Service',
              subtitle: 'boardgamegeek.com/terms',
              uri: 'https://www.boardgamegeek.com/terms'),
        ],
      ),
    );
  }
}

class _PluginsAndLibrariesSection extends StatelessWidget {
  const _PluginsAndLibrariesSection();

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          SectionText(text: AppText.aboutPagePluginsAndLibrariesSubtitle),
          DetailsItem(
            title: 'Animations',
            subtitle: 'Pre-built animations for Flutter',
            uri: 'https://pub.dev/packages/animations',
          ),
          DetailsItem(
            title: 'Archive',
            subtitle: 'Dart library that compresses files',
            uri: 'https://pub.dev/packages/archive',
          ),
          DetailsItem(
            title: 'Async',
            subtitle: 'Utilies for asynchronous code',
            uri: 'https://pub.dev/packages/async',
          ),
          DetailsItem(
            title: 'Basics',
            subtitle: 'Collection of useful extension methods on built-in objects in Dart',
            uri: 'https://pub.dev/packages/basics',
          ),
          DetailsItem(
            title: 'Cached Network Image',
            subtitle: 'Caching network images',
            uri: 'https://pub.dev/packages/cached_network_image',
          ),
          DetailsItem(
            title: 'Collection',
            subtitle: 'Utilites to make working with collections easier',
            uri: 'https://pub.dev/packages/collection',
          ),
          DetailsItem(
            title: 'Convex BottomAppBar',
            subtitle: 'Prettier bottom app bar',
            uri: 'https://pub.dev/packages/convex_bottom_bar',
          ),
          DetailsItem(
            title: 'File picker',
            subtitle: 'Native file explorer to pick files',
            uri: 'https://pub.dev/packages/file_picker',
          ),
          DetailsItem(
            title: 'Fimber',
            subtitle: 'Handles in app logs',
            uri: 'https://pub.dev/packages/fimber',
          ),
          DetailsItem(
            title: 'Firebase Crashlytics',
            subtitle: 'Captures app crash analytics',
            uri: 'https://pub.dev/packages/firebase_crashlytics',
          ),
          DetailsItem(
            title: 'FL Chart',
            subtitle: 'Chart library',
            uri: 'https://pub.dev/packages/fl_chart',
          ),
          DetailsItem(
            title: 'Mobx',
            subtitle: 'State management library',
            uri: 'https://pub.dev/packages/flutter_mobx',
          ),
          DetailsItem(
            title: 'Ploygon',
            subtitle: 'Helps with creating polygon shapes',
            uri: 'https://pub.dev/packages/flutter_polygon',
          ),
          DetailsItem(
            title: 'Slidable',
            subtitle: 'Adds ability to slide and action list items',
            uri: 'https://pub.dev/packages/flutter_slidable',
          ),
          DetailsItem(
            title: 'Speed dial',
            subtitle: 'Speed dial context menu',
            uri: 'https://pub.dev/packages/flutter_speed_dial',
          ),
          DetailsItem(
            title: 'SVG',
            subtitle: 'Draws SVG files',
            uri: 'https://pub.dev/packages/flutter_svg',
          ),
          DetailsItem(
            title: 'Font Awesome',
            subtitle: 'Icons pack',
            uri: 'https://pub.dev/packages/font_awesome_flutter',
          ),
          DetailsItem(
            title: 'Freezed',
            subtitle: 'Data models code generator',
            uri: 'https://pub.dev/packages/freezed',
          ),
          DetailsItem(
            title: 'Google Fonts - Lato Font',
            subtitle: 'Font used across the entire app',
            uri: 'https://pub.dev/packages/google_fonts',
          ),
          DetailsItem(
            title: 'Get it',
            subtitle: 'Dependency injection',
            uri: 'https://pub.dev/packages/get_it',
          ),
          DetailsItem(
            title: 'Hive',
            subtitle: 'NoSQL Database',
            uri: 'https://pub.dev/packages/hive',
          ),
          DetailsItem(
            title: 'Html Unespace',
            subtitle: 'Helps unescaping HTML-encoded strings',
            uri: 'https://pub.dev/packages/html_unescape',
          ),
          DetailsItem(
            title: 'Path Provider',
            subtitle: 'Helps with filesystem paths',
            uri: 'https://pub.dev/packages/path_provider',
          ),
          DetailsItem(
            title: 'Image Picker',
            subtitle: 'Picking images and taking photos with camera',
            uri: 'https://pub.dev/packages/image_picker',
          ),
          DetailsItem(
            title: 'XML',
            subtitle: 'Parsing XML API responses',
            uri: 'https://pub.dev/packages/xml',
          ),
          DetailsItem(
            title: 'Url Launcher',
            subtitle: "Launching Uri's",
            uri: 'https://pub.dev/packages/url_launcher',
          ),
        ],
      ),
    );
  }
}

class _PrivacyPolicyFooter extends StatelessWidget {
  const _PrivacyPolicyFooter();

  static const String privactyPolicyUrl =
      'https://progrunning.net/board-games-companion-privacy-policy/';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.accentColor,
        child: const Padding(
          padding: EdgeInsets.symmetric(
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
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () async => LauncherHelper.launchUri(context, privactyPolicyUrl),
      ),
    );
  }
}

class _LicensePageDetailsItem extends StatelessWidget {
  const _LicensePageDetailsItem();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder(
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
                      applicationName: AppText.appTitle,
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
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ],
            );
          }

          return const LoadingIndicator();
        },
      ),
    );
  }
}
