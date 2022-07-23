import 'package:basics/basics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../common/rank_ribbon.dart';
import '../common/ripple_effect.dart';

class BoardGameTile extends StatefulWidget {
  const BoardGameTile({
    Key? key,
    required this.id,
    required this.imageUrl,
    this.name,
    this.rank,
    this.onTap,
    this.heroTag = AnimationTags.boardGameHeroTag,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String? name;
  final int? rank;
  final Future<void> Function()? onTap;
  final String heroTag;

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: '${widget.heroTag}${widget.id}',
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsets.only(
                right: Dimensions.halfStandardSpacing,
                bottom: Dimensions.halfStandardSpacing,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[AppTheme.defaultBoxShadow],
                  borderRadius: AppTheme.defaultBoxRadius,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: AppTheme.defaultBoxRadius,
              ),
            ),
            errorWidget: (context, url, dynamic error) => Container(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[AppTheme.defaultBoxShadow],
                borderRadius: AppTheme.defaultBoxRadius,
                color: AppTheme.primaryColor,
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage('assets/icons/logo.png'),
                ),
              ),
            ),
          ),
        ),
        if (widget.name.isNotNullOrBlank) _Name(name: widget.name!),
        if (widget.rank != null && widget.rank! < Constants.top100)
          Positioned(
            top: 0,
            right: 12,
            child: RankRibbon(rank: widget.rank!),
          ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              right: Dimensions.halfStandardSpacing,
              bottom: Dimensions.halfStandardSpacing,
            ),
            child: RippleEffect(borderRadius: AppTheme.defaultBoxRadius, onTap: widget.onTap),
          ),
        )
      ],
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

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
            color: AppTheme.accentColor.withAlpha(Styles.opacity70Percent),
            borderRadius: const BorderRadius.all(
              Radius.circular(Styles.defaultCornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: Dimensions.smallFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
