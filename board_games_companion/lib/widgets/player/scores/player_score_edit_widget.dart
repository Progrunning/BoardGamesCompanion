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
        decoration: InputDecoration(
          labelText: 'Score',
          fillColor: Colors.red,
        ),
        onFieldSubmitted: (value) async {
          _onSubmit(value);
        },
      ),
    );
  }
}
