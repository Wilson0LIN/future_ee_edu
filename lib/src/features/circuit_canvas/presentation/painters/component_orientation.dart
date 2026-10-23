import 'package:flutter/material.dart';

/// Enum representing standard 90-degree component orientations on the grid.
enum ComponentOrientation {
  /// Horizontal orientation pointing Right (0°).
  deg0(0),

  /// Vertical orientation pointing Down (90°).
  deg90(90),

  /// Horizontal orientation pointing Left (180°).
  deg180(180),

  /// Vertical orientation pointing Up (270°).
  deg270(270);

  /// Rotation angle in degrees.
  final int degrees;

  const ComponentOrientation(this.degrees);

  /// Longitudinal unit vector pointing from Pin 1 to Pin 2.
  Offset get direction {
    switch (this) {
      case ComponentOrientation.deg0:
        return const Offset(1, 0);
      case ComponentOrientation.deg90:
        return const Offset(0, 1);
      case ComponentOrientation.deg180:
        return const Offset(-1, 0);
      case ComponentOrientation.deg270:
        return const Offset(0, -1);
    }
  }

  /// Normal unit vector perpendicular to the orientation axis.
  Offset get normal {
    final d = direction;
    return Offset(-d.dy, d.dx);
  }

  /// Infers orientation from a vector pointing from Pin 1 to Pin 2.
  static ComponentOrientation fromVector(Offset vector) {
    if (vector.dx == 0 && vector.dy == 0) return ComponentOrientation.deg0;

    if (vector.dx.abs() >= vector.dy.abs()) {
      return vector.dx >= 0
          ? ComponentOrientation.deg0
          : ComponentOrientation.deg180;
    } else {
      return vector.dy >= 0
          ? ComponentOrientation.deg90
          : ComponentOrientation.deg270;
    }
  }
}
