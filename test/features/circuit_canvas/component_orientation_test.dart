import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/component_orientation.dart';

void main() {
  group('ComponentOrientation Unit Tests', () {
    test('direction vectors match expected angles', () {
      expect(ComponentOrientation.deg0.direction, const Offset(1, 0));
      expect(ComponentOrientation.deg90.direction, const Offset(0, 1));
      expect(ComponentOrientation.deg180.direction, const Offset(-1, 0));
      expect(ComponentOrientation.deg270.direction, const Offset(0, -1));
    });

    test('normal vectors are perpendicular to direction vectors', () {
      expect(ComponentOrientation.deg0.normal, const Offset(0, 1));
      expect(ComponentOrientation.deg90.normal, const Offset(-1, 0));
      expect(ComponentOrientation.deg180.normal, const Offset(0, -1));
      expect(ComponentOrientation.deg270.normal, const Offset(1, 0));
    });

    test('fromVector correctly infers 90-degree orientations', () {
      expect(
        ComponentOrientation.fromVector(const Offset(100, 0)),
        equals(ComponentOrientation.deg0),
      );
      expect(
        ComponentOrientation.fromVector(const Offset(0, 150)),
        equals(ComponentOrientation.deg90),
      );
      expect(
        ComponentOrientation.fromVector(const Offset(-80, 0)),
        equals(ComponentOrientation.deg180),
      );
      expect(
        ComponentOrientation.fromVector(const Offset(0, -200)),
        equals(ComponentOrientation.deg270),
      );
    });
  });
}
