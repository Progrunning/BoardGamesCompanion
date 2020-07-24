import 'package:flutter/material.dart';

class DebugBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const DebugBox({
    @required this.child,
    this.color = Colors.red,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }
}
