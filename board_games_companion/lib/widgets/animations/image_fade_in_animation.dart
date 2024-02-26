import 'package:flutter/material.dart';

class ImageFadeInAnimation extends StatelessWidget {
  const ImageFadeInAnimation({
    required this.frame,
    required this.child,
    super.key,
  });

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
