import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/resistor_painter.dart';

void main() {
  group('ResistorPainter Unit Tests', () {
    test('snapToGrid correctly snaps continuous values to 20px grid', () {
      expect(ResistorPainter.snapToGrid(0.0), 0.0);
      expect(ResistorPainter.snapToGrid(9.9), 0.0);
      expect(ResistorPainter.snapToGrid(10.0), 20.0);
      expect(ResistorPainter.snapToGrid(18.5), 20.0);
      expect(ResistorPainter.snapToGrid(31.2), 40.0);
      expect(ResistorPainter.snapToGrid(49.0), 40.0);
      expect(ResistorPainter.snapToGrid(50.0), 60.0);
    });

    test('pinPositions are integer-snapped on a 20px grid', () {
      const painter = ResistorPainter(
        start: Offset(12.3, 19.8),
        end: Offset(101.5, 41.0),
      );

      final pins = painter.pinPositions;
      expect(pins.length, 2);

      expect(pins[0], const Offset(20.0, 20.0));
      expect(pins[1], const Offset(100.0, 40.0));

      expect(painter.leftPin, const Offset(20.0, 20.0));
      expect(painter.rightPin, const Offset(100.0, 40.0));
    });

    test('Custom grid size snapping works as expected', () {
      const painter = ResistorPainter(
        start: Offset(14.0, 26.0),
        end: Offset(35.0, 50.0),
        gridSize: 10.0,
      );

      final pins = painter.pinPositions;
      expect(pins[0], const Offset(10.0, 30.0));
      expect(pins[1], const Offset(40.0, 50.0));
    });

    test('Resistor path generation handles non-zero distance', () {
      const startPin = Offset(0, 20);
      const endPin = Offset(100, 20);
      final path = ResistorPainter.getResistorPath(startPin, endPin);

      expect(path, isNotNull);
      final bounds = path.getBounds();
      expect(bounds.left, equals(0.0));
      expect(bounds.right, equals(100.0));
    });
  });
}
