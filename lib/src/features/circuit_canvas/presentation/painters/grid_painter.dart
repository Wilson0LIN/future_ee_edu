import 'package:flutter/material.dart';

/// Painter that draws a background grid with grid lines spaced [gridSize] apart (defaults to 20px).
class GridPainter extends CustomPainter {
  /// Grid spacing in logical pixels.
  final double gridSize;

  /// Line color for the grid lines.
  final Color gridColor;

  /// Stroke width for grid lines.
  final double strokeWidth;

  const GridPainter({
    this.gridSize = 20.0,
    this.gridColor = const Color(0xFFE0E0E0),
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
