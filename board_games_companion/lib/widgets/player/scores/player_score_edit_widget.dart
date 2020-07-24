import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class PlayerScoreEdit extends StatelessWidget {
  final TextEditingController _controller;
  final void Function(String) _onSubmit;

  const PlayerScoreEdit({
    @required controller,
    @required onSubmit,
    Key key,
  })  : _controller = controller,
        _onSubmit = onSubmit,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: Dimensions.extraLargeFontSize,
          color: AppTheme.accentColor,
        ),
        decoration: InputDecoration(
          labelText: 'Score',
          labelStyle: AppTheme.sectionHeaderTextStyle,
          fillColor: Colors.red,
        ),
        onFieldSubmitted: (value) async {
          _onSubmit(value);
        },
      ),
    );
  }
}
