import 'package:flutter/material.dart';
import 'component_orientation.dart';
import 'latex_label_painter.dart';

/// CustomPainter for rendering an IEEE standard zigzag resistor with 3Blue1Brown aesthetics,
/// strict pin anchoring, integer grid snapping, and LaTeX label formatting.
class ResistorPainter extends CustomPainter {
  /// Optional start position of the resistor component (Pin 1).
  final Offset? start;

  /// Optional end position of the resistor component (Pin 2).
  final Offset? end;

  /// Optional center position of the resistor component.
  final Offset? center;

  /// Optional orientation of the resistor component.
  final ComponentOrientation? orientation;

  /// Length of the resistor between terminal pins when center + orientation are used.
  final double length;

  /// Grid size used for snapping coordinates (defaults to 20.0).
  final double gridSize;

  /// Color of the resistor lines (defaults to 3b1b Neon Amber #F59E0B).
  final Color color;

  /// Stroke width of the resistor lines (defaults to 3.5px).
  final double strokeWidth;

  /// Optional LaTeX label to display (e.g., "$R_1 = 10\\,\\Omega$").
  final String? label;

  /// Whether to draw crisp terminal white node dots at component pins.
  final bool drawTerminalDots;

  const ResistorPainter({
    this.start,
    this.end,
    this.center,
    this.orientation,
    this.length = 120.0,
    this.gridSize = 20.0,
    this.color = const Color(0xFFF59E0B), // 3b1b Neon Amber
    this.strokeWidth = 3.5,
    this.label,
    this.drawTerminalDots = true,
  });

  /// Factory constructor for center grid coordinate and orientation positioning.
  factory ResistorPainter.fromCenter({
    required Offset center,
    required ComponentOrientation orientation,
    double length = 120.0,
    double gridSize = 20.0,
    Color color = const Color(0xFFF59E0B),
    double strokeWidth = 3.5,
    String? label,
    bool drawTerminalDots = true,
  }) {
    return ResistorPainter(
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

  /// Connection Pin positions (strictly integer-snapped to grid, e.g. 20px).
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
      final p1 = snapOffset(start ?? const Offset(0, 20), gridSize);
      final p2 = snapOffset(end ?? const Offset(100, 20), gridSize);
      return [p1, p2];
    }
  }

  /// Connection pin 1 (start / left / top).
  Offset get leftPin => pinPositions[0];

  /// Connection pin 2 (end / right / bottom).
  Offset get rightPin => pinPositions[1];

  /// Computes the exact geometric center coordinate of the resistor component.
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

    final path = getResistorPath(p1, p2);

    // 1. Subtle neon glow pass
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, glowPaint);

    // 2. Core crisp line pass
    final corePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, corePaint);

    // 3. Draw terminal node dots if requested
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

    // 4. Draw LaTeX component label with collision avoidance & background shield
    if (label != null && label!.trim().isNotEmpty) {
      LatexLabelPainter.paintLabel(
        canvas: canvas,
        rawLabel: label!,
        midPoint: centerPosition,
        normalDirection: effectiveOrientation.normal,
        color: color,
        canvasSize: size,
        componentBounds: path.getBounds(),
      );
    }
  }

  /// Computes the IEEE zigzag path between terminal pins [p1] and [p2].
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
