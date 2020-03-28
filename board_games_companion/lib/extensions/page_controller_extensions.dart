import 'package:flutter/material.dart';

extension PageControllerExtensions on PageController {
  Future<void> animateToTab(int tabIndex) {
    return animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
