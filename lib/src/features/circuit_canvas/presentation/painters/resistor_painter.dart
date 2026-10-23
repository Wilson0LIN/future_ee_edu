import 'package:flutter/material.dart';

/// CustomPainter for rendering an IEEE standard zigzag resistor on a grid canvas.
class ResistorPainter extends CustomPainter {
  /// Start position of the resistor component.
  final Offset start;

  /// End position of the resistor component.
  final Offset end;

  /// Grid size used for snapping coordinates (defaults to 20.0).
  final double gridSize;

  /// Color of the resistor lines. Defaults to Sky Blue (#38BDF8) for dark background high contrast.
  final Color color;

  /// Stroke width of the resistor lines. Defaults to 3.0.
  final double strokeWidth;

  const ResistorPainter({
    this.start = const Offset(0, 20),
    this.end = const Offset(100, 20),
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

  /// Connection Pin positions (snapped to grid, e.g. 20px).
  List<Offset> get pinPositions => [
    snapOffset(start, gridSize),
    snapOffset(end, gridSize),
  ];

  /// Connection pin on the left / start.
  Offset get leftPin => pinPositions[0];

  /// Connection pin on the right / end.
  Offset get rightPin => pinPositions[1];

  @override
  void paint(Canvas canvas, Size size) {
    final pins = pinPositions;
    final p1 = pins[0];
    final p2 = pins[1];

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = getResistorPath(p1, p2);
    canvas.drawPath(path, paint);
  }

  /// Computes the IEEE zigzag path between [p1] and [p2].
  static Path getResistorPath(Offset p1, Offset p2) {
    final path = Path();
    final vector = p2 - p1;
    final distance = vector.distance;

    if (distance == 0) {
      path.moveTo(p1.dx, p1.dy);
      return path;
    }

    final u = vector / distance;
    final n = Offset(-u.dy, u.dx);

    final bodyLength = distance >= 40
        ? (distance * 0.6).clamp(30.0, distance - 20.0)
        : distance;
    final leadLength = (distance - bodyLength) / 2;

    final zStart = p1 + u * leadLength;
    final zEnd = p1 + u * (leadLength + bodyLength);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(zStart.dx, zStart.dy);

    const int peaks = 6;
    final stepLength = bodyLength / peaks;
    final peakHeight = (stepLength).clamp(6.0, 12.0);

    path.lineTo(
      (zStart + u * (stepLength * 0.5) + n * peakHeight).dx,
      (zStart + u * (stepLength * 0.5) + n * peakHeight).dy,
    );

    for (int i = 1; i < peaks; i++) {
      final side = (i % 2 == 1) ? -1.0 : 1.0;
      final point =
          zStart + u * (stepLength * (i + 0.5)) + n * (peakHeight * side);
      path.lineTo(point.dx, point.dy);
    }

    path.lineTo(zEnd.dx, zEnd.dy);
    path.lineTo(p2.dx, p2.dy);

    return path;
  }

  @override
  bool shouldRepaint(covariant ResistorPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
