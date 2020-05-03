import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

class BggCommunityMemberUserNameTextField extends StatelessWidget {
  const BggCommunityMemberUserNameTextField({
    Key key,
    @required TextEditingController controller,
    @required Function() onSubmit,
  })  : _controller = controller,
        _onSubmit = onSubmit,
        super(key: key);

  final TextEditingController _controller;
  final Function _onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
        hintText: 'Enter your BGG user\'s name',
      ),
      onSubmitted: (username) {
        _onSubmit();
      },
    );
  }
}
