import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../utilities/launcher_helper.dart';
import '../about/about_page.dart';
import '../settings/settings_page.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: AppColors.primaryColor,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.doubleStandardSpacing,
                vertical: Dimensions.doubleStandardSpacing * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
              appStoreId: Constants.appleAppId,
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          _MenuItem(
            icon: Icons.settings,
            title: AppText.settingsPageTitle,
            onTap: () async => Navigator.pushNamed(context, SettingsPage.pageRoute),
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentColor),
      title: Text(
        title,
        style: AppTheme.theme.textTheme.bodyLarge!,
      ),
      onTap: onTap,
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => LauncherHelper.launchUri(context, Constants.appReleaseNotesUrl),
      child: const Padding(
        padding: EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          children: [
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
  const _VersionNumber();

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
