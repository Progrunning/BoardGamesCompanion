import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';

class VersionNumber extends StatelessWidget {
  const VersionNumber({
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
          return Padding(
            padding: const EdgeInsets.all(
              Dimensions.halfStandardSpacing,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'v${(snapshot.data as PackageInfo).version}',
                style: AppTheme.subTitleTextStyle,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
