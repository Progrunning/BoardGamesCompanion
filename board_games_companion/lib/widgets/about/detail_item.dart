import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../utilities/launcher_helper.dart';
import '../common/shadow_box.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    @required this.title,
    @required this.subtitle,
    this.iconUri,
    this.onTap,
    this.uri,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String iconUri;
  final VoidCallback onTap;
  final String uri;

  static const double _size = 60;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppTheme.accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
            horizontal: Dimensions.standardSpacing,
          ),
          child: SizedBox(
            height: (iconUri?.isNotEmpty ?? false) ? _size : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (iconUri?.isNotEmpty ?? false)
                  ShadowBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
                      child: Image(
                        height: _size,
                        width: _size,
                        image: AssetImage(iconUri),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (iconUri?.isNotEmpty ?? false)
                  const SizedBox(
                    width: Dimensions.standardSpacing,
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        title,
                        style: AppTheme.theme.textTheme.headline3.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.halfStandardSpacing,
                      ),
                      Text(
                        subtitle,
                        style: AppTheme.theme.textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          if (onTap != null) {
            onTap();
          }

          if (uri?.isEmpty ?? true) {
            return;
          }

          await LauncherHelper.launchUri(
            context,
            uri,
          );
        },
      ),
    );
  }
}
