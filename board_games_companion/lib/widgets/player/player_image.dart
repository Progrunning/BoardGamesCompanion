import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../animations/image_fade_in_animation.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({
    super.key,
    required this.imageUri,
    this.place,
  });

  final String imageUri;
  final int? place;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // MK Reducing used memory when caching player avatar images.
        //
        // NOTE 1: Multiplying the size of the image to ensure there's no pixelation effect.
        // NOTE 2: Using only one dimension (longer one) to let the caching logic work out the aspect ratio of the image
        int? imageCacheWidth;
        int? imageCacheHeight;
        if (constraints.maxHeight > constraints.maxWidth) {
          imageCacheHeight = (constraints.maxHeight * 1.5).toInt();
        } else {
          imageCacheWidth = (constraints.maxWidth * 1.5).toInt();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
          child: Stack(
            children: [
              const _Placeholder(),
              Positioned.fill(
                child: Image.file(
                  File(imageUri),
                  fit: BoxFit.cover,
                  cacheHeight: imageCacheHeight,
                  cacheWidth: imageCacheWidth,
                  frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }

                    return ImageFadeInAnimation(frame: frame, child: child);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
        ),
      );
}
