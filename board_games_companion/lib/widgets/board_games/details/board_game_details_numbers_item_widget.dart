import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsNumbersItem extends StatelessWidget {
  BoardGameDetailsNumbersItem({
    Key key,
    @required String title,
    @required String detail,
    bool format = false,
  })  : _title = title,
        _detail = detail,
        _format = format,
        super(key: key);

  final String _title;
  final String _detail;
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
            text: _formatNumber(),
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber() {
    if (_detail?.isEmpty ?? true) {
      return '';
    }

    final number = num.tryParse(_detail);
    if (number == null) {
      return _detail;
    }

    if (!_format || number < 1000) {
      return number.toString();
    }

    final numberOfThousands = number / 1000;
    return '${numberOfThousands.round()}k';
  }
}
