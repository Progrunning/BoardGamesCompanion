import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  final String text;

  const SectionText({
    @required this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      child: Text(
        text,
        style: AppTheme.theme.textTheme.display1,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
