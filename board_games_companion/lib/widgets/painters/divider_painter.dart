import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
