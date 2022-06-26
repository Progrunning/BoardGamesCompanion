import 'package:flutter/material.dart';

import '../../common/app_theme.dart';

class BggCommunityMemberUserNameTextField extends StatelessWidget {
  const BggCommunityMemberUserNameTextField({
    Key? key,
    required TextEditingController controller,
    required Function() onSubmit,
  })  : _controller = controller,
        _onSubmit = onSubmit,
        super(key: key);

  final TextEditingController _controller;
  final Function _onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: AppTheme.defaultTextFieldStyle,
      decoration: const InputDecoration(
        hintText: "Enter your BGG's username",
      ),
      onSubmitted: (username) {
        _onSubmit();
      },
    );
  }
}
