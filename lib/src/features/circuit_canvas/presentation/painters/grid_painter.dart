import 'package:flutter/material.dart';

/// Painter that renders a 3Blue1Brown inspired dark canvas with subtle dot-grid intersections.
class GridPainter extends CustomPainter {
  /// Grid spacing in logical pixels (defaults to 20.0).
  final double gridSize;

  /// Background color for the canvas (defaults to deep slate dark #0F172A).
  final Color backgroundColor;

  /// Dot color for grid intersections.
  final Color dotColor;

  /// Dot radius in logical pixels.
  final double dotRadius;

  /// Whether to show the subtle dot grid.
  final bool showDots;

  const GridPainter({
    this.gridSize = 20.0,
    this.backgroundColor = const Color(0xFF0F172A),
    this.dotColor = const Color(0x3394A3B8), // Slate 400 with 20% opacity
    this.dotRadius = 1.2,
    this.showDots = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill deep slate background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (!showDots) return;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = 0; x <= size.width; x += gridSize) {
      for (double y = 0; y <= size.height; y += gridSize) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.showDots != showDots;
  }
}
