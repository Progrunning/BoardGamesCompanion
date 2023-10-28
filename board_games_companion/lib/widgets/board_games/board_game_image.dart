import 'dart:io';

import 'package:basics/basics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../extensions/string_extensions.dart';
import '../animations/image_fade_in_animation.dart';
import '../common/bgc_shimmer.dart';

class BoardGameImage extends StatelessWidget {
  const BoardGameImage({
    required String? url,
    String? id,
    this.minImageHeight = 300,
    this.heroTag = AnimationTags.boardGameHeroTag,
    Key? key,
  })  : _id = id,
        _url = url,
        super(key: key);

  final double minImageHeight;
  final String heroTag;

  final String? _id;
  final String? _url;

  @override
  Widget build(BuildContext context) {
    final image = _url.toImageType().when(
          web: () {
            return CachedNetworkImage(
              imageUrl: _url!,
              imageBuilder: (context, imageProvider) => ConstrainedBox(
                constraints: BoxConstraints(minHeight: minImageHeight),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              fit: BoxFit.fitWidth,
              placeholder: (_, __) => BgcShimmer.box(),
              errorWidget: (_, __, dynamic ___) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minImageHeight),
                  child: Image.asset('assets/icons/logo.png', fit: BoxFit.cover),
                );
              },
            );
          },
          file: () {
            return Image.file(
              File(_url!),
              fit: BoxFit.cover,
              cacheHeight: minImageHeight.toInt(),
              frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }

                return ImageFadeInAnimation(frame: frame, child: child);
              },
            );
          },
          undefined: () => ConstrainedBox(
            constraints: BoxConstraints(minHeight: minImageHeight),
            child: Image.asset('assets/icons/logo.png', fit: BoxFit.cover),
          ),
        );

    if (_id.isNotNullOrBlank) {
      return Hero(tag: '$heroTag$_id', child: image);
    }

    return image;
  }
}
