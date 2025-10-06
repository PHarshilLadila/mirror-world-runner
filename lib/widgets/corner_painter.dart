// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CornerPainter extends CustomPainter {
  final Alignment alignment;

  CornerPainter({required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final path = Path();

    if (alignment == Alignment.topLeft) {
      path.moveTo(10, 10);
      path.lineTo(30, 10);
      path.moveTo(10, 10);
      path.lineTo(10, 30);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width - 10, 10);
      path.lineTo(size.width - 30, 10);
      path.moveTo(size.width - 10, 10);
      path.lineTo(size.width - 10, 30);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(10, size.height - 10);
      path.lineTo(30, size.height - 10);
      path.moveTo(10, size.height - 10);
      path.lineTo(10, size.height - 30);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width - 10, size.height - 10);
      path.lineTo(size.width - 30, size.height - 10);
      path.moveTo(size.width - 10, size.height - 10);
      path.lineTo(size.width - 10, size.height - 30);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
