import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsCreditsItem extends StatelessWidget {
  const BoardGameDetailsCreditsItem({
    @required title,
    @required detail,
    Key key,
  })  : _title = title,
        _detail = detail,
        super(key: key);

  final String _title;
  final String _detail;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _title ?? '',
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: _detail ?? '',
          ),
        ],
      ),
    );
  }
}
