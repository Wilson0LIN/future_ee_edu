import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/wire_painter.dart';

void main() {
  group('WirePainter Unit Tests', () {
    test('snapToGrid correctly snaps continuous values to 20px grid', () {
      expect(WirePainter.snapToGrid(0.0), 0.0);
      expect(WirePainter.snapToGrid(12.0), 20.0);
      expect(WirePainter.snapToGrid(35.0), 40.0);
    });

    test('snappedPoints and pinPositions snap all control points to grid', () {
      const points = [
        Offset(101.2, 100.8),
        Offset(379.5, 99.1),
        Offset(380.2, 138.9),
        Offset(421.0, 140.0),
      ];

      final painter = WirePainter(points: points);
      final snapped = painter.snappedPoints;

      expect(snapped[0], const Offset(100.0, 100.0));
      expect(snapped[1], const Offset(380.0, 100.0));
      expect(snapped[2], const Offset(380.0, 140.0));
      expect(snapped[3], const Offset(420.0, 140.0));

      final pins = painter.pinPositions;
      expect(pins.length, 2);
      expect(pins[0], const Offset(100.0, 100.0));
      expect(pins[1], const Offset(420.0, 140.0));
    });

    test(
      'computeOrthogonalPoints calculates 90-degree corner points correctly',
      () {
        const start = Offset(101, 100);
        const end = Offset(180, 260);

        // Horizontal first: Start -> (end.dx, start.dy) -> End
        final pathHorizontal = WirePainter.computeOrthogonalPoints(
          start,
          end,
          horizontalFirst: true,
        );

        expect(pathHorizontal.length, 3);
        expect(pathHorizontal[0], const Offset(100, 100));
        expect(pathHorizontal[1], const Offset(180, 100));
        expect(pathHorizontal[2], const Offset(180, 260));

        // Vertical first: Start -> (start.dx, end.dy) -> End
        final pathVertical = WirePainter.computeOrthogonalPoints(
          start,
          end,
          horizontalFirst: false,
        );

        expect(pathVertical.length, 3);
        expect(pathVertical[0], const Offset(100, 100));
        expect(pathVertical[1], const Offset(100, 260));
        expect(pathVertical[2], const Offset(180, 260));
      },
    );
  });
}
