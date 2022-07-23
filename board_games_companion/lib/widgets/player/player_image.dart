import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({
    Key? key,
    this.place,
    this.imageUri,
  }) : super(key: key);

  final String? imageUri;
  final int? place;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
      child: Stack(
        children: [
          const _Placeholder(),
          Builder(
            builder: (_) {
              if ((imageUri?.isEmpty ?? true) || imageUri == Constants.defaultAvatartAssetsPath) {
                return Positioned.fill(
                  child: Image.asset(
                    Constants.defaultAvatartAssetsPath,
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child, int? frame,
                        bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }

                      return _FadeInAnimation(frame: frame, child: child);
                    },
                  ),
                );
              }

              return Positioned.fill(
                child: Image.file(
                  File(imageUri!),
                  fit: BoxFit.cover,
                  frameBuilder: (BuildContext context, Widget child, int? frame,
                      bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }

                    return _FadeInAnimation(frame: frame, child: child);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FadeInAnimation extends StatelessWidget {
  const _FadeInAnimation({
    required this.frame,
    required this.child,
    Key? key,
  }) : super(key: key);

  final int? frame;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
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
        borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
      ),
    );
  }
}
