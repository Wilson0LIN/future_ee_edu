import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/main.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/screens/circuit_canvas_screen.dart';

void main() {
  testWidgets('App renders CircuitCanvasScreen successfully', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that CircuitCanvasScreen and its title are present
    expect(find.byType(CircuitCanvasScreen), findsOneWidget);
    expect(find.text('3b1b Series-Parallel Circuit Canvas'), findsOneWidget);
  });
}
