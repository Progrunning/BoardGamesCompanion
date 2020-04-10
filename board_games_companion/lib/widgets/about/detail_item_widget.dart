import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:board_games_companion/widgets/common/debug_box.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:flutter/material.dart';

class DetailsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconUri;
  final CallbackAction onTap;
  final String uri;

  static const double _size = 60;

  const DetailsItem({
    @required this.title,
    @required this.subtitle,
    this.iconUri,
    this.onTap,
    this.uri,
    Key key,
  }) : super(key: key);

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
          child: Container(
            height: (iconUri?.isNotEmpty ?? false) ? _size : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (iconUri?.isNotEmpty ?? false)
                  ShadowBox(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Styles.defaultCornerRadius),
                      child: Image(
                        height: _size,
                        width: _size,
                        image: AssetImage(iconUri),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (iconUri?.isNotEmpty ?? false)
                  SizedBox(
                    width: Dimensions.standardSpacing,
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        title,
                        style: AppTheme.theme.textTheme.display2,
                      ),
                      SizedBox(
                        height: Dimensions.halfStandardSpacing,
                      ),
                      Text(
                        subtitle,
                        style: AppTheme.theme.textTheme.subhead,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          await LauncherHelper.launchUri(
            context,
            uri,
          );
        },
      ),
    );
  }
}
