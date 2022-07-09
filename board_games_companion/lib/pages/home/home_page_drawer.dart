import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info/package_info.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../about/about_page.dart';
import '../settings/settings_page.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: AppTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.doubleStandardSpacing,
                vertical: Dimensions.doubleStandardSpacing * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Image(image: AssetImage('assets/icons/logo_transparent.png')),
                  ),
                  SizedBox(height: Dimensions.standardSpacing),
                  Text(AppText.appTitle, style: AppTheme.titleTextStyle),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          _MenuItem(
            icon: Icons.info,
            title: AppText.aboutPageTitle,
            onTap: () async => Navigator.pushNamed(context, AboutPage.pageRoute),
          ),
          _MenuItem(
            icon: Icons.menu_book_sharp,
            title: AppText.drawerAppWiki,
            onTap: () async => LauncherHelper.launchUri(context, Constants.appWikiFeaturesUrl),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          const Divider(),
          const SizedBox(height: Dimensions.standardSpacing),
          _MenuItem(
            icon: Icons.star,
            title: AppText.rateAndReview,
            onTap: () async => InAppReview.instance.openStoreListing(
              appStoreId: Constants.AppleAppId,
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          _MenuItem(
            icon: Icons.settings,
            title: AppText.settingsPageTitle,
            onTap: () async => Navigator.pushNamed(context, SettingsPage.pageRoute),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          const Divider(),
          const SizedBox(height: Dimensions.standardSpacing),
          _MenuItem(
            icon: Icons.coffee,
            title: AppText.drawerBuyMeACoffe,
            onTap: () async => LauncherHelper.launchUri(context, Constants.buyMeACoffeeUrl),
          ),
          const Expanded(child: SizedBox.shrink()),
          const Divider(),
          const _Footer(),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentColor),
      title: Text(
        title,
        style: AppTheme.theme.textTheme.bodyText1!,
      ),
      onTap: onTap,
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => LauncherHelper.launchUri(context, Constants.appReleaseNotesUrl),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          children: const [
            _VersionNumber(),
            SizedBox(height: Dimensions.halfStandardSpacing),
            Text(AppText.drawerReleaseNotes),
          ],
        ),
      ),
    );
  }
}

class _VersionNumber extends StatelessWidget {
  const _VersionNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data is PackageInfo) {
          return Center(
            child: Text(
              sprintf(
                  AppText.drawerVersionFormat, <String>[(snapshot.data as PackageInfo).version]),
              style: AppTheme.subTitleTextStyle,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
