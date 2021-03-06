import 'package:flutter/material.dart';

import '../../common/app_theme.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    this.starCount = 10,
    this.rating = .0,
    this.color = Colors.yellow,
    this.size = 15,
    Key? key,
  }) : super(key: key);

  final int starCount;
  final double rating;
  final Color color;
  final double size;

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: size,
        color: AppTheme.accentColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size,
        color: color,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size,
        color: color,
      );
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        starCount,
        (index) => buildStar(context, index),
      ),
    );
  }
}
