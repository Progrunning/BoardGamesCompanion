import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class PlayerScoreEdit extends StatelessWidget {
  const PlayerScoreEdit({
    @required this.controller,
    @required this.onSubmit,
    Key key,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: Dimensions.extraLargeFontSize,
          color: AppTheme.accentColor,
        ),
        decoration: const InputDecoration(
          labelText: 'Score',
          labelStyle: AppTheme.sectionHeaderTextStyle,
          fillColor: Colors.red,
        ),
        onFieldSubmitted: (value) async {
          onSubmit(value);
        },
      ),
    );
  }
}
