import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsInfoPanel extends StatelessWidget {
  const BoardGameDetailsInfoPanel({
    @required title,
    subtitle,
    Key key,
  })  : _title = title,
        _subtitle = subtitle,
        super(key: key);

  final String _title;
  final String _subtitle;

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      child: Container(
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.halfStandardSpacing,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _title ?? '',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleTextStyle,
                ),
                if (_subtitle?.isNotEmpty ?? false)
                  Text(
                    _subtitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.subTitleTextStyle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
