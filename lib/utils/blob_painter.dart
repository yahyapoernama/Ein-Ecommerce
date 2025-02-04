import 'package:flutter/material.dart';

class BlobPainter extends CustomPainter {
  final Color color;

  BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Blob di bagian atas
    final path = Path()
      ..moveTo(0, size.height * 0.1)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.005,
        size.width * 0.75,
        size.height * 0.3,
        size.width,
        size.height * 0.05,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    // Blob di bagian bawah
    final path2 = Path()
      ..moveTo(0, size.height - 50)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.9,
        size.width * 0.75,
        size.height * 1.1,
        size.width,
        size.height * 0.9,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}