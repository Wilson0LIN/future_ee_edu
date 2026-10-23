import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/voltage_source_painter.dart';

void main() {
  group('VoltageSourcePainter Unit Tests', () {
    test('snapToGrid correctly snaps continuous values to 20px grid', () {
      expect(VoltageSourcePainter.snapToGrid(0.0), 0.0);
      expect(VoltageSourcePainter.snapToGrid(11.2), 20.0);
      expect(VoltageSourcePainter.snapToGrid(28.9), 20.0);
      expect(VoltageSourcePainter.snapToGrid(31.0), 40.0);
    });

    test('pinPositions are integer-snapped on a 20px grid', () {
      const painter = VoltageSourcePainter(
        start: Offset(98.2, 101.5),
        end: Offset(102.1, 259.0),
      );

      final pins = painter.pinPositions;
      expect(pins.length, 2);

      expect(pins[0], const Offset(100.0, 100.0));
      expect(pins[1], const Offset(100.0, 260.0));

      expect(painter.positivePin, const Offset(100.0, 100.0));
      expect(painter.negativePin, const Offset(100.0, 260.0));
    });

    test('shouldRepaint returns correct boolean based on properties', () {
      const painter1 = VoltageSourcePainter(
        start: Offset(100, 100),
        end: Offset(100, 260),
        color: Colors.blue,
      );
      const painter2 = VoltageSourcePainter(
        start: Offset(100, 100),
        end: Offset(100, 260),
        color: Colors.blue,
      );
      const painter3 = VoltageSourcePainter(
        start: Offset(100, 100),
        end: Offset(100, 260),
        color: Colors.red,
      );

      expect(painter1.shouldRepaint(painter2), isFalse);
      expect(painter1.shouldRepaint(painter3), isTrue);
    });
  });
}
