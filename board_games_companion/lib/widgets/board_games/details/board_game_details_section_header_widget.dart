import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsSectionHeader extends StatelessWidget {
  const BoardGameDetailsSectionHeader({
    @required title,
    Key key,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _title,
            style: AppTheme.sectionHeaderTextStyle,
          ),
          SizedBox(
            height: Dimensions.halfStandardSpacing,
          ),
        ],
      ),
    );
  }
}
