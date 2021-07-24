import 'package:flutter/material.dart';

class DebugBox extends StatelessWidget {
  const DebugBox({
    @required this.child,
    this.color = Colors.red,
    Key key,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }
}
