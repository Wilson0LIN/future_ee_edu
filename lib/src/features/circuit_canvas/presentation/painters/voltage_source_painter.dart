import 'package:flutter/material.dart';

/// CustomPainter for rendering a DC Voltage Source with 3Blue1Brown aesthetics.
class VoltageSourcePainter extends CustomPainter {
  /// Start position (positive / top terminal).
  final Offset start;

  /// End position (negative / bottom terminal).
  final Offset end;

  /// Grid size for snapping (defaults to 20.0).
  final double gridSize;

  /// Color of the voltage source (defaults to Sky Blue #38BDF8).
  final Color color;

  /// Stroke width (defaults to 3.5px).
  final double strokeWidth;

  /// Optional label (e.g., "Vs (12V)").
  final String? label;

  const VoltageSourcePainter({
    this.start = const Offset(40, 40),
    this.end = const Offset(40, 140),
    this.gridSize = 20.0,
    this.color = const Color(0xFF38BDF8), // 3b1b Sky Blue
    this.strokeWidth = 3.5,
    this.label,
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

  /// Explicit terminal pins snapped to grid.
  List<Offset> get pinPositions => [
    snapOffset(start, gridSize),
    snapOffset(end, gridSize),
  ];

  Offset get positivePin => pinPositions[0];
  Offset get negativePin => pinPositions[1];

  @override
  void paint(Canvas canvas, Size size) {
    final pins = pinPositions;
    final p1 = pins[0];
    final p2 = pins[1];

    final vector = p2 - p1;
    final distance = vector.distance;
    if (distance == 0) return;

    final u = vector / distance; // Unit vector along leads
    final n = Offset(-u.dy, u.dx); // Normal vector

    final circleRadius = (distance * 0.25).clamp(16.0, 30.0);
    final center = p1 + vector / 2;

    final lead1End = center - u * circleRadius;
    final lead2Start = center + u * circleRadius;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final corePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Draw Leads
    canvas.drawLine(p1, lead1End, glowPaint);
    canvas.drawLine(p1, lead1End, corePaint);

    canvas.drawLine(lead2Start, p2, glowPaint);
    canvas.drawLine(lead2Start, p2, corePaint);

    // 2. Draw Circle Symbol
    canvas.drawCircle(center, circleRadius, glowPaint);
    canvas.drawCircle(center, circleRadius, corePaint);

    // 3. Draw '+' and '-' inside or near source
    final plusPos = center - u * (circleRadius * 0.45);
    final minusPos = center + u * (circleRadius * 0.45);

    // Plus sign '+'
    final plusSize = circleRadius * 0.3;
    final plusPath = Path()
      ..moveTo(plusPos.dx - plusSize / 2, plusPos.dy)
      ..lineTo(plusPos.dx + plusSize / 2, plusPos.dy)
      ..moveTo(plusPos.dx, plusPos.dy - plusSize / 2)
      ..lineTo(plusPos.dx, plusPos.dy + plusSize / 2);

    canvas.drawPath(plusPath, glowPaint);
    canvas.drawPath(plusPath, corePaint);

    // Minus sign '-'
    final minusPath = Path()
      ..moveTo(minusPos.dx - plusSize / 2, minusPos.dy)
      ..lineTo(minusPos.dx + plusSize / 2, minusPos.dy);

    canvas.drawPath(minusPath, glowPaint);
    canvas.drawPath(minusPath, corePaint);

    // 4. Label if present
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

      final labelPos =
          center -
          n * (circleRadius + 18) -
          Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, labelPos);
    }
  }

  @override
  bool shouldRepaint(covariant VoltageSourcePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.label != label;
  }
}
