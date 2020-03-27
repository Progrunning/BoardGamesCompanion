import 'package:flutter/material.dart';

class DebugBox extends StatelessWidget {
  final Color color;

  const DebugBox({
    Key key,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
    );
  }
}
