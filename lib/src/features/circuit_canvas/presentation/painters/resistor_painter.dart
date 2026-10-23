import 'package:flutter/material.dart';

/// CustomPainter for rendering an IEEE standard zigzag resistor with 3Blue1Brown aesthetics.
class ResistorPainter extends CustomPainter {
  /// Start position of the resistor component.
  final Offset start;

  /// End position of the resistor component.
  final Offset end;

  /// Grid size used for snapping coordinates (defaults to 20.0).
  final double gridSize;

  /// Color of the resistor lines (defaults to 3b1b Neon Amber #F59E0B).
  final Color color;

  /// Stroke width of the resistor lines (defaults to 3.5px).
  final double strokeWidth;

  /// Optional label to display (e.g., "R1 (10Ω)").
  final String? label;

  const ResistorPainter({
    this.start = const Offset(0, 20),
    this.end = const Offset(100, 20),
    this.gridSize = 20.0,
    this.color = const Color(0xFFF59E0B), // 3b1b Neon Amber
    this.strokeWidth = 3.5,
    this.label,
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

    final path = getResistorPath(p1, p2);

    // Subtle neon glow pass
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, glowPaint);

    // Core crisp line pass
    final corePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, corePaint);

    // Draw component label if provided
    if (label != null && label!.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: color.withValues(alpha: 0.8), blurRadius: 4),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final midPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      // Offset perpendicular to the orientation
      final vector = p2 - p1;
      final distance = vector.distance;
      final offsetDirection = distance > 0
          ? Offset(-vector.dy / distance, vector.dx / distance)
          : const Offset(0, -1);

      final labelPos =
          midPoint +
          offsetDirection * 22 -
          Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, labelPos);
    }
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
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.label != label;
  }
}
