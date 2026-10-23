import 'package:flutter/material.dart';

/// CustomPainter for rendering a DC Voltage Source / Battery symbol on a grid canvas.
class VoltageSourcePainter extends CustomPainter {
  /// Start position of the voltage source (positive terminal pin).
  final Offset start;

  /// End position of the voltage source (negative terminal pin).
  final Offset end;

  /// Grid size used for snapping coordinates (defaults to 20.0).
  final double gridSize;

  /// Color of the voltage source lines. Defaults to Sky Blue (#38BDF8).
  final Color color;

  /// Stroke width of the lines. Defaults to 3.0.
  final double strokeWidth;

  /// Optional label or voltage string (e.g. "12V").
  final String? label;

  const VoltageSourcePainter({
    this.start = const Offset(100, 100),
    this.end = const Offset(100, 220),
    this.gridSize = 20.0,
    this.color = const Color(0xFF38BDF8),
    this.strokeWidth = 3.0,
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

  /// Positive terminal pin.
  Offset get positivePin => pinPositions[0];

  /// Negative terminal pin.
  Offset get negativePin => pinPositions[1];

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

    final vector = p2 - p1;
    final distance = vector.distance;

    if (distance == 0) {
      canvas.drawCircle(p1, strokeWidth, paint);
      return;
    }

    final u = vector / distance; // Direction unit vector from p1 to p2
    final n = Offset(-u.dy, u.dx); // Normal unit vector (perpendicular)

    // Center area for the battery plates
    final center = p1 + vector * 0.5;
    const plateSpacing = 12.0;
    final posPlateCenter = center - u * (plateSpacing / 2);
    final negPlateCenter = center + u * (plateSpacing / 2);

    // Lead lines from pins to plates
    canvas.drawLine(p1, posPlateCenter, paint);
    canvas.drawLine(negPlateCenter, p2, paint);

    // Long plate (Positive terminal)
    const longPlateHalfLength = 20.0;
    canvas.drawLine(
      posPlateCenter - n * longPlateHalfLength,
      posPlateCenter + n * longPlateHalfLength,
      paint,
    );

    // Short plate (Negative terminal) - slightly thicker or shorter line
    const shortPlateHalfLength = 10.0;
    final thickPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      negPlateCenter - n * shortPlateHalfLength,
      negPlateCenter + n * shortPlateHalfLength,
      thickPaint,
    );

    // Draw '+' sign near positive terminal
    final plusPos = posPlateCenter - u * 12 + n * 16;
    const plusSize = 6.0;
    canvas.drawLine(
      plusPos - Offset(plusSize, 0),
      plusPos + Offset(plusSize, 0),
      paint..strokeWidth = 2.0,
    );
    canvas.drawLine(
      plusPos - Offset(0, plusSize),
      plusPos + Offset(0, plusSize),
      paint..strokeWidth = 2.0,
    );

    // Draw '-' sign near negative terminal
    final minusPos = negPlateCenter + u * 12 + n * 16;
    canvas.drawLine(
      minusPos - Offset(plusSize, 0),
      minusPos + Offset(plusSize, 0),
      paint..strokeWidth = 2.0,
    );

    if (label != null && label!.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        center -
            n * (longPlateHalfLength + textPainter.width + 8) -
            Offset(0, textPainter.height / 2),
      );
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
