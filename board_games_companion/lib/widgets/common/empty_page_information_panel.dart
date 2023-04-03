import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

import '../../common/dimensions.dart';

class EmptyPageInformationPanel extends StatelessWidget {
  const EmptyPageInformationPanel({
    required this.title,
    required this.icon,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget icon;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: Dimensions.extraLargeFontSize),
            ),
          ),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          icon,
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          if (subtitle.isNotNullOrBlank)
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(text: subtitle),
                ],
              ),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: Dimensions.mediumFontSize),
            ),
        ],
      ),
    );
  }
}
