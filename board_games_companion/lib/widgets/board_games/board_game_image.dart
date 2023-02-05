import 'package:basics/basics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../common/loading_indicator_widget.dart';

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
    if (_url.isNullOrBlank) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minImageHeight),
        child: Image.asset('assets/icons/logo.png', fit: BoxFit.cover),
      );
    }

    final image = CachedNetworkImage(
      imageUrl: _url ?? '',
      imageBuilder: (context, imageProvider) => ConstrainedBox(
        constraints: BoxConstraints(minHeight: minImageHeight),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
      fit: BoxFit.fitWidth,
      placeholder: (_, __) => const LoadingIndicator(),
      errorWidget: (_, __, dynamic ___) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: minImageHeight),
          child: Image.asset('assets/icons/logo.png', fit: BoxFit.cover),
        );
      },
    );

    if (_id.isNotNullOrBlank) {
      return Hero(tag: '$heroTag$_id', child: image);
    }

    return image;
  }
}
