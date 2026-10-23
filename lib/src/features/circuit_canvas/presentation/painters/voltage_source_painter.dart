import 'package:flutter/material.dart';
import 'component_orientation.dart';
import 'latex_label_painter.dart';

/// CustomPainter for rendering a DC Voltage Source with 3Blue1Brown aesthetics,
/// strict pin anchoring, integer grid snapping, and LaTeX label formatting.
class VoltageSourcePainter extends CustomPainter {
  /// Optional start position (positive terminal / Pin 1).
  final Offset? start;

  /// Optional end position (negative terminal / Pin 2).
  final Offset? end;

  /// Optional center position of the voltage source.
  final Offset? center;

  /// Optional orientation of the voltage source.
  final ComponentOrientation? orientation;

  /// Length between terminals when center + orientation are used.
  final double length;

  /// Grid size for snapping (defaults to 20.0).
  final double gridSize;

  /// Color of the voltage source (defaults to Sky Blue #38BDF8).
  final Color color;

  /// Stroke width (defaults to 3.5px).
  final double strokeWidth;

  /// Optional LaTeX label (e.g., "$V_s = 12\\,\\text{V}$").
  final String? label;

  /// Whether to draw crisp white terminal node dots at component pins.
  final bool drawTerminalDots;

  const VoltageSourcePainter({
    this.start,
    this.end,
    this.center,
    this.orientation,
    this.length = 160.0,
    this.gridSize = 20.0,
    this.color = const Color(0xFF38BDF8), // 3b1b Sky Blue
    this.strokeWidth = 3.5,
    this.label,
    this.drawTerminalDots = true,
  });

  /// Factory constructor for center grid coordinate and orientation positioning.
  factory VoltageSourcePainter.fromCenter({
    required Offset center,
    required ComponentOrientation orientation,
    double length = 160.0,
    double gridSize = 20.0,
    Color color = const Color(0xFF38BDF8),
    double strokeWidth = 3.5,
    String? label,
    bool drawTerminalDots = true,
  }) {
    return VoltageSourcePainter(
      center: center,
      orientation: orientation,
      length: length,
      gridSize: gridSize,
      color: color,
      strokeWidth: strokeWidth,
      label: label,
      drawTerminalDots: drawTerminalDots,
    );
  }

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

  /// Explicit terminal pins strictly integer-snapped to grid.
  List<Offset> get pinPositions {
    if (center != null && orientation != null) {
      final snappedCenter = snapOffset(center!, gridSize);
      final dir = orientation!.direction;
      final halfLen = length / 2;
      return [
        snapOffset(snappedCenter - dir * halfLen, gridSize),
        snapOffset(snappedCenter + dir * halfLen, gridSize),
      ];
    } else if (start != null && end != null) {
      return [snapOffset(start!, gridSize), snapOffset(end!, gridSize)];
    } else {
      final p1 = snapOffset(start ?? const Offset(40, 40), gridSize);
      final p2 = snapOffset(end ?? const Offset(40, 140), gridSize);
      return [p1, p2];
    }
  }

  Offset get positivePin => pinPositions[0];
  Offset get negativePin => pinPositions[1];

  /// Center coordinate of the voltage source symbol.
  Offset get centerPosition {
    if (center != null) return snapOffset(center!, gridSize);
    final pins = pinPositions;
    return Offset((pins[0].dx + pins[1].dx) / 2, (pins[0].dy + pins[1].dy) / 2);
  }

  /// Inferred or explicit component orientation.
  ComponentOrientation get effectiveOrientation {
    if (orientation != null) return orientation!;
    final pins = pinPositions;
    return ComponentOrientation.fromVector(pins[1] - pins[0]);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pins = pinPositions;
    final p1 = pins[0];
    final p2 = pins[1];

    final vector = p2 - p1;
    final distance = vector.distance;
    if (distance == 0) return;

    final u = vector / distance; // Unit vector along leads
    final circleRadius = (distance * 0.25).clamp(16.0, 30.0);
    final centerPt = centerPosition;

    final lead1End = centerPt - u * circleRadius;
    final lead2Start = centerPt + u * circleRadius;

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

    // 1. Draw Leads strictly from terminal pins to circle boundary
    canvas.drawLine(p1, lead1End, glowPaint);
    canvas.drawLine(p1, lead1End, corePaint);

    canvas.drawLine(lead2Start, p2, glowPaint);
    canvas.drawLine(lead2Start, p2, corePaint);

    // 2. Draw Circle Symbol
    canvas.drawCircle(centerPt, circleRadius, glowPaint);
    canvas.drawCircle(centerPt, circleRadius, corePaint);

    // 3. Draw '+' and '-' inside circle
    final plusPos = centerPt - u * (circleRadius * 0.45);
    final minusPos = centerPt + u * (circleRadius * 0.45);

    final plusSize = circleRadius * 0.3;
    final plusPath = Path()
      ..moveTo(plusPos.dx - plusSize / 2, plusPos.dy)
      ..lineTo(plusPos.dx + plusSize / 2, plusPos.dy)
      ..moveTo(plusPos.dx, plusPos.dy - plusSize / 2)
      ..lineTo(plusPos.dx, plusPos.dy + plusSize / 2);

    canvas.drawPath(plusPath, glowPaint);
    canvas.drawPath(plusPath, corePaint);

    final minusPath = Path()
      ..moveTo(minusPos.dx - plusSize / 2, minusPos.dy)
      ..lineTo(minusPos.dx + plusSize / 2, minusPos.dy);

    canvas.drawPath(minusPath, glowPaint);
    canvas.drawPath(minusPath, corePaint);

    // 4. Draw terminal node dots at component pins
    if (drawTerminalDots) {
      final dotGlow = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      final dotCore = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      for (final pt in pins) {
        canvas.drawCircle(pt, 5.0, dotGlow);
        canvas.drawCircle(pt, 3.5, dotCore);
      }
    }

    // 5. Draw LaTeX label with background shield and collision avoidance
    if (label != null && label!.trim().isNotEmpty) {
      LatexLabelPainter.paintLabel(
        canvas: canvas,
        rawLabel: label!,
        midPoint: centerPt,
        normalDirection: effectiveOrientation.normal,
        color: color,
        canvasSize: size,
        componentBounds: Rect.fromCircle(
          center: centerPt,
          radius: circleRadius,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant VoltageSourcePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.center != center ||
        oldDelegate.orientation != orientation ||
        oldDelegate.length != length ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.label != label ||
        oldDelegate.drawTerminalDots != drawTerminalDots;
  }
}
