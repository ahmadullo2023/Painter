import 'dart:ui';
import 'package:flutter/material.dart';
import '../model/line_model.dart';

class MyPainter extends CustomPainter {
  const MyPainter({required this.lines});

  final List<LineData> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (final offsets in lines) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = offsets.strokeWidth
        ..color = offsets.color;

      if (offsets.points.length == 1) {
        canvas.drawPoints(PointMode.points, offsets.points, paint);
      } else {
        final path = Path()..addPolygon(offsets.points, false);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) =>
      lines != oldDelegate.lines;
}
