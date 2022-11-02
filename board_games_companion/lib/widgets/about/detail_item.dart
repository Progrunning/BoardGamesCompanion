import 'package:basics/basics.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../utilities/launcher_helper.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    required this.title,
    required this.subtitle,
    this.assetIconUri,
    this.onTap,
    this.uri,
    this.isSvg = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String? assetIconUri;
  final VoidCallback? onTap;
  final String? uri;
  final bool isSvg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
            horizontal: Dimensions.standardSpacing,
          ),
          child: SizedBox(
            height: (assetIconUri.isNotNullOrBlank) ? Dimensions.detailsItemHeight : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (assetIconUri.isNotNullOrBlank)
                  ElevatedContainer(
                    elevation: AppStyles.defaultElevation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                      child: isSvg
                          ? SvgPicture.asset(
                              assetIconUri!,
                              height: Dimensions.detailsItemHeight,
                              width: Dimensions.detailsItemHeight,
                            )
                          : Image(
                              height: Dimensions.detailsItemHeight,
                              width: Dimensions.detailsItemHeight,
                              image: AssetImage(assetIconUri!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                if (assetIconUri?.isNotEmpty ?? false)
                  const SizedBox(width: Dimensions.standardSpacing),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        title,
                        style: AppTheme.theme.textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: Dimensions.halfStandardSpacing),
                      Text(subtitle, style: AppTheme.theme.textTheme.subtitle1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          if (onTap != null) {
            onTap!();
          }

          if (uri?.isEmpty ?? true) {
            return;
          }

          await LauncherHelper.launchUri(context, uri!);
        },
      ),
    );
  }
}
