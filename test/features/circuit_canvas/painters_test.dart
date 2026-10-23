import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/grid_painter.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/resistor_painter.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/voltage_source_painter.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/wire_painter.dart';

void main() {
  group('3b1b Circuit Painters Tests', () {
    test('GridPainter renders with default 3b1b colors', () {
      const painter = GridPainter();
      expect(painter.backgroundColor, equals(const Color(0xFF0F172A)));
      expect(painter.gridSize, equals(20.0));
      expect(painter.showDots, isTrue);
    });

    test('ResistorPainter pinPositions and 3b1b defaults', () {
      const painter = ResistorPainter(
        start: Offset(22.0, 161.0),
        end: Offset(379.0, 158.0),
      );

      final pins = painter.pinPositions;
      expect(pins.length, equals(2));
      expect(pins[0], equals(const Offset(20.0, 160.0)));
      expect(pins[1], equals(const Offset(380.0, 160.0)));
      expect(painter.color, equals(const Color(0xFFF59E0B)));
      expect(painter.strokeWidth, equals(3.5));
    });

    test('VoltageSourcePainter pinPositions and 3b1b defaults', () {
      const painter = VoltageSourcePainter(
        start: Offset(101.0, 160.0),
        end: Offset(99.0, 360.0),
      );

      final pins = painter.pinPositions;
      expect(pins.length, equals(2));
      expect(pins[0], equals(const Offset(100.0, 160.0)));
      expect(pins[1], equals(const Offset(100.0, 360.0)));
      expect(painter.color, equals(const Color(0xFF38BDF8)));
      expect(painter.strokeWidth, equals(3.5));
    });

    test('WirePainter pinPositions and 3b1b defaults', () {
      const painter = WirePainter(
        points: [Offset(101.0, 160.0), Offset(219.0, 160.0)],
      );

      final pins = painter.pinPositions;
      expect(pins.length, equals(2));
      expect(pins[0], equals(const Offset(100.0, 160.0)));
      expect(pins[1], equals(const Offset(220.0, 160.0)));
      expect(painter.color, equals(const Color(0xFF38BDF8)));
      expect(painter.strokeWidth, equals(3.5));
    });
  });
}
