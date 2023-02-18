import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/constants.dart';
import '../animations/image_fade_in_animation.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({
    Key? key,
    this.place,
    this.imageUri,
    this.avatarImageSize,
  }) : super(key: key);

  final String? imageUri;
  final int? place;

  final Size? avatarImageSize;

  @override
  Widget build(BuildContext context) {
    // MK Reducing used memory when caching player avatar images.
    //
    // NOTE 1: Multiplying the size of the image to ensure there's no pixelation effect.
    // NOTE 2: Using only one dimension (longer one) to let the caching logic work out the aspect ratio of the image
    int? avatarImageCacheWidth;
    int? avatarImageCacheHeight;
    if (avatarImageSize != null) {
      if (avatarImageSize!.height > avatarImageSize!.width) {
        avatarImageCacheHeight = (avatarImageSize!.height * 1.5).toInt();
      } else {
        avatarImageCacheWidth = (avatarImageSize!.width * 1.5).toInt();
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
      child: Stack(
        children: [
          const _Placeholder(),
          if ((imageUri?.isEmpty ?? true) || imageUri == Constants.defaultAvatartAssetsPath)
            Positioned.fill(
              child: Image.asset(
                Constants.defaultAvatartAssetsPath,
                fit: BoxFit.cover,
                frameBuilder:
                    (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }

                  return ImageFadeInAnimation(frame: frame, child: child);
                },
              ),
            )
          else
            Positioned.fill(
              child: Image.file(
                File(imageUri!),
                fit: BoxFit.cover,
                cacheHeight: avatarImageCacheHeight,
                cacheWidth: avatarImageCacheWidth,
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
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
      ),
    );
  }
}
