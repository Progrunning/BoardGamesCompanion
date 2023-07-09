// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/widgets/common/bgc_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../extensions/string_extensions.dart';
import '../animations/image_fade_in_animation.dart';
import '../common/rank_ribbon.dart';
import '../common/ripple_effect.dart';
import 'board_game_name.dart';

class BoardGameTile extends StatelessWidget {
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
    this.borderRadius = AppTheme.defaultBorderRadius,
    this.minImageSize = Dimensions.boardGameItemCollectionImageWidth,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String? name;
  final double nameFontSize;
  final int? rank;
  final Future<void> Function()? onTap;
  final String heroTag;
  final double? elevation;
  final BorderRadiusGeometry borderRadius;
  final double minImageSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 0,
      borderRadius: borderRadius,
      shadowColor: AppColors.primaryColor,
      child: Stack(
        children: <Widget>[
          imageUrl.toImageType().when(
                web: () => _WebImage(
                  heroTag: heroTag,
                  id: id,
                  imageUrl: imageUrl,
                  borderRadius: borderRadius,
                ),
                file: () => _FileImage(
                  heroTag: heroTag,
                  id: id,
                  imageUrl: imageUrl,
                  borderRadius: borderRadius,
                  minImageSize: minImageSize,
                ),
                undefined: () => _NoImage(borderRadius: borderRadius),
              ),
          if (name.isNotNullOrBlank)
            Align(
              alignment: Alignment.bottomCenter,
              child: BoardGameName(name: name!, fontSize: nameFontSize),
            ),
          if (rank != null && rank! < Constants.top100)
            Positioned(top: 0, right: 12, child: RankRibbon(rank: rank!)),
          Positioned.fill(
            child: RippleEffect(borderRadius: borderRadius.resolve(null), onTap: onTap),
          )
        ],
      ),
    );
  }
}

class _FileImage extends StatelessWidget {
  const _FileImage({
    Key? key,
    required this.heroTag,
    required this.id,
    required this.imageUrl,
    required this.borderRadius,
    required this.minImageSize,
  }) : super(key: key);

  final String heroTag;
  final String id;
  final String imageUrl;
  final BorderRadiusGeometry borderRadius;
  final double minImageSize;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Hero(
        tag: '$heroTag$id',
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,

            /// The assumption is that the image will be wider than taller, therefore size reduction
            /// (i.e. caching) based on the height of the image will have a lesser impact on the quality.
            cacheHeight: minImageSize.toInt(),
            frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }

              return ImageFadeInAnimation(frame: frame, child: child);
            },
          ),
        ),
      ),
    );
  }
}

class _WebImage extends StatelessWidget {
  const _WebImage({
    Key? key,
    required this.heroTag,
    required this.id,
    required this.imageUrl,
    required this.borderRadius,
  }) : super(key: key);

  final String heroTag;
  final String id;
  final String imageUrl;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$heroTag$id',
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => BgcShimmer(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: borderRadius,
            ),
          ),
        ),
        errorWidget: (context, url, dynamic error) => _NoImage(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.primaryColor,
        image: const DecorationImage(
          alignment: Alignment.center,
          image: AssetImage('assets/icons/logo.png'),
        ),
      ),
    );
  }
}
