import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoardGameDetailsNumbersItem extends StatelessWidget {
  BoardGameDetailsNumbersItem({
    Key key,
    @required String title,
    @required num number,
  })  : _title = title,
        _number = number,
        super(key: key);

  final String _title;
  final num _number;
  final NumberFormat _numberFormat = NumberFormat('### ### ###.0#');

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$_title: ',
          ),
          TextSpan(
            text: _number != null ? _numberFormat.format(_number) : '',
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
