import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionText extends StatelessWidget {
  const SectionText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      child: Text(
        text,
        style: AppTheme.theme.textTheme.headlineMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
