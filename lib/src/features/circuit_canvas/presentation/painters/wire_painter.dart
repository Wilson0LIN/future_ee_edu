import 'package:flutter/material.dart';

/// CustomPainter for rendering 90-degree orthogonal connecting wires snapped to a grid canvas.
class WirePainter extends CustomPainter {
  /// Sequence of control points defining the wire path.
  final List<Offset> points;

  /// Grid size used for snapping coordinates (defaults to 20.0).
  final double gridSize;

  /// Color of the wire line. Defaults to Sky Blue (#38BDF8).
  final Color color;

  /// Stroke width of the wire line. Defaults to 3.0.
  final double strokeWidth;

  const WirePainter({
    required this.points,
    this.gridSize = 20.0,
    this.color = const Color(0xFF38BDF8),
    this.strokeWidth = 3.0,
  });

  /// Snaps a value to the nearest grid step.
  static double snapToGrid(double value, [double gridSize = 20.0]) {
    return (value / gridSize).round() * gridSize;
  }

  /// Snaps an Offset to the nearest grid coordinates.
  static Offset snapOffset(Offset offset, [double gridSize = 20.0]) {
    return Offset(
      snapToGrid(offset.dx, gridSize),
      snapToGrid(offset.dy, gridSize),
    );
  }

  /// Returns snapped control points along the wire path.
  List<Offset> get snappedPoints =>
      points.map((p) => snapOffset(p, gridSize)).toList();

  /// Connection Pin positions (typically end points of the wire).
  List<Offset> get pinPositions {
    final snapped = snappedPoints;
    if (snapped.isEmpty) return [];
    if (snapped.length == 1) return [snapped.first];
    return [snapped.first, snapped.last];
  }

  /// Helper to create a 2-point orthogonal route between [start] and [end].
  /// If [horizontalFirst] is true, routes horizontally then vertically (Start -> (end.dx, start.dy) -> End).
  /// If false, routes vertically then horizontally (Start -> (start.dx, end.dy) -> End).
  static List<Offset> computeOrthogonalPoints(
    Offset start,
    Offset end, {
    bool horizontalFirst = true,
    double gridSize = 20.0,
  }) {
    final s = snapOffset(start, gridSize);
    final e = snapOffset(end, gridSize);

    if (s.dx == e.dx || s.dy == e.dy) {
      return [s, e];
    }

    final corner = horizontalFirst ? Offset(e.dx, s.dy) : Offset(s.dx, e.dy);

    return [s, corner, e];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pts = snappedPoints;
    if (pts.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw small junction/terminal dots at start and end points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pts.first, strokeWidth, dotPaint);
    canvas.drawCircle(pts.last, strokeWidth, dotPaint);
  }

  @override
  bool shouldRepaint(covariant WirePainter oldDelegate) {
    if (oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.points.length != points.length) {
      return true;
    }
    for (int i = 0; i < points.length; i++) {
      if (oldDelegate.points[i] != points[i]) return true;
    }
    return false;
  }
}
