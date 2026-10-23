import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/main.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/circuit_canvas_screen.dart';

void main() {
  testWidgets(
    'CircuitApp renders CircuitCanvasScreen with title and info overlay',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CircuitApp());

      // Verify AppBar title is present
      expect(find.text('Circuit Topology Canvas'), findsOneWidget);

      // Verify CircuitCanvasScreen widget is in tree
      expect(find.byType(CircuitCanvasScreen), findsOneWidget);

      // Verify topology text overlay is displayed
      expect(find.text('Topology: Series-Parallel Circuit'), findsOneWidget);
      expect(
        find.text('Grid: 20px x 20px | Orthogonal 90° Wires'),
        findsOneWidget,
      );

      // Verify component labels
      expect(find.text('R1 (Series: 100 Ω)'), findsOneWidget);
      expect(find.text('R2 (Parallel: 200 Ω)'), findsOneWidget);
      expect(find.text('R3 (Parallel: 200 Ω)'), findsOneWidget);
      expect(find.text('V1 (12V)'), findsOneWidget);
    },
  );
}
