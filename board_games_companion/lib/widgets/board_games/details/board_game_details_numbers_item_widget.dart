import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsNumbersItem extends StatelessWidget {
  BoardGameDetailsNumbersItem({
    Key key,
    @required String title,
    @required num number,
    bool format = false,
  })  : _title = title,
        _number = number,
        _format = format,
        super(key: key);

  final String _title;
  final num _number;
  final bool _format;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$_title: ',
          ),
          TextSpan(
            text: _formatNumber(_number, _format),
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _formatNumber(num number, bool format) {
    if (_number == null || !format || number < 1000) {
      return number?.toString() ?? '';
    }

    final numberOfThousands = number / 1000;
    return '${numberOfThousands.round()}k';
  }
}
