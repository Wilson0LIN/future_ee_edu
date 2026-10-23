import 'package:flutter/material.dart';

/// CustomPainter for rendering orthogonal wire connections with 3Blue1Brown aesthetics.
class WirePainter extends CustomPainter {
  /// Ordered list of points defining the wire path (must contain at least 2 points).
  final List<Offset> points;

  /// Grid size for snapping (defaults to 20.0).
  final double gridSize;

  /// Color of the wire path (defaults to Sky Blue #38BDF8).
  final Color color;

  /// Stroke width of the wire (defaults to 3.5px).
  final double strokeWidth;

  /// Whether to draw connection node dots at the start/end points.
  final bool drawTerminalDots;

  const WirePainter({
    required this.points,
    this.gridSize = 20.0,
    this.color = const Color(0xFF38BDF8), // 3b1b Sky Blue
    this.strokeWidth = 3.5,
    this.drawTerminalDots = false,
  });

  /// Snaps a value to nearest grid step.
  static double snapToGrid(double value, [double gridSize = 20.0]) {
    return (value / gridSize).round() * gridSize;
  }

  /// Snaps an Offset to grid.
  static Offset snapOffset(Offset offset, [double gridSize = 20.0]) {
    return Offset(
      snapToGrid(offset.dx, gridSize),
      snapToGrid(offset.dy, gridSize),
    );
  }

  /// Explicit connection pin positions snapped to grid.
  List<Offset> get pinPositions =>
      points.map((p) => snapOffset(p, gridSize)).toList();

  @override
  void paint(Canvas canvas, Size size) {
    final snappedPoints = pinPositions;
    if (snappedPoints.length < 2) return;

    final path = Path()..moveTo(snappedPoints.first.dx, snappedPoints.first.dy);
    for (int i = 1; i < snappedPoints.length; i++) {
      path.lineTo(snappedPoints[i].dx, snappedPoints[i].dy);
    }

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final corePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, corePaint);

    if (drawTerminalDots) {
      final dotGlow = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      final dotCore = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      for (final pt in [snappedPoints.first, snappedPoints.last]) {
        canvas.drawCircle(pt, 5.0, dotGlow);
        canvas.drawCircle(pt, 3.5, dotCore);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WirePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.drawTerminalDots != drawTerminalDots;
  }
}
