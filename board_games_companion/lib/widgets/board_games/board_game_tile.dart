import 'package:basics/basics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../common/rank_ribbon.dart';
import '../common/ripple_effect.dart';

class BoardGameTile extends StatefulWidget {
  const BoardGameTile({
    Key? key,
    required this.id,
    required this.imageUrl,
    this.name,
    this.nameFontSize = Dimensions.smallFontSize,
    this.rank,
    this.onTap,
    this.heroTag = AnimationTags.boardGameHeroTag,
    this.elevation,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String? name;
  final double nameFontSize;
  final int? rank;
  final Future<void> Function()? onTap;
  final String heroTag;
  final double? elevation;

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation ?? 0,
      borderRadius: AppTheme.defaultBoxRadius,
      shadowColor: AppColors.primaryColor,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: '${widget.heroTag}${widget.id}',
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: AppTheme.defaultBoxRadius,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: AppTheme.defaultBoxRadius,
                ),
              ),
              errorWidget: (context, url, dynamic error) => Container(
                decoration: const BoxDecoration(
                  borderRadius: AppTheme.defaultBoxRadius,
                  color: AppColors.primaryColor,
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage('assets/icons/logo.png'),
                  ),
                ),
              ),
            ),
          ),
          if (widget.name.isNotNullOrBlank)
            _Name(
              name: widget.name!,
              fontSize: widget.nameFontSize,
            ),
          if (widget.rank != null && widget.rank! < Constants.top100)
            Positioned(
              top: 0,
              right: 12,
              child: RankRibbon(rank: widget.rank!),
            ),
          Positioned.fill(
            child: RippleEffect(borderRadius: AppTheme.defaultBoxRadius, onTap: widget.onTap),
          )
        ],
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    Key? key,
    required this.name,
    required this.fontSize,
  }) : super(key: key);

  final String name;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Dimensions.standardSpacing,
        left: Dimensions.halfStandardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppStyles.defaultCornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.defaultTextColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
