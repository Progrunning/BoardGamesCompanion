import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class NavigatorTransitions {
  static const int defaultDurationInMilliseconds = 1000;

  static Route<T> fadeThrough<T>(RoutePageBuilder page,
      [int duration = defaultDurationInMilliseconds]) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: defaultDurationInMilliseconds),
      pageBuilder: (context, animation, secondaryAnimation) =>
          page(context, animation, secondaryAnimation),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  static Route<T> fadeScale<T>(
    RoutePageBuilder page, [
    int duration = defaultDurationInMilliseconds,
  ]) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: defaultDurationInMilliseconds),
      pageBuilder: (context, animation, secondaryAnimation) =>
          page(context, animation, secondaryAnimation),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(
          animation: animation,
          child: child,
        );
      },
    );
  }

  static Route<T> sharedAxis<T>(RoutePageBuilder page,
      [SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
      int duration = defaultDurationInMilliseconds]) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: defaultDurationInMilliseconds),
      pageBuilder: (context, animation, secondaryAnimation) =>
          page(context, animation, secondaryAnimation),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
        );
      },
    );
  }
}
