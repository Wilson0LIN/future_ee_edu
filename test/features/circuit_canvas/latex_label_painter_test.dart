import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_ee_edu/src/features/circuit_canvas/presentation/painters/latex_label_painter.dart';

void main() {
  group('LatexLabelPainter Unit Tests', () {
    test(
      'toSubscript converts numbers and letters to subscript characters',
      () {
        expect(LatexLabelPainter.toSubscript('1'), equals('₁'));
        expect(LatexLabelPainter.toSubscript('s'), equals('ₛ'));
        expect(LatexLabelPainter.toSubscript('in'), equals('ᵢₙ'));
        expect(LatexLabelPainter.toSubscript('20'), equals('₂₀'));
      },
    );

    test('buildMathTextSpan parses LaTeX formulas into rich TextSpan', () {
      final span = LatexLabelPainter.buildMathTextSpan(
        r'$R_1 = 10\,\Omega$',
        color: const Color(0xFFF59E0B),
      );

      expect(span, isNotNull);
      final textContent = span.toPlainText();
      expect(textContent, contains('R₁ = 10 Ω'));
    });

    test('buildMathTextSpan parses voltage source formulas', () {
      final span = LatexLabelPainter.buildMathTextSpan(
        r'$V_s = 12\,\text{V}$',
        color: const Color(0xFF38BDF8),
      );

      final textContent = span.toPlainText();
      expect(textContent, contains('Vₛ = 12 V'));
    });

    test('computeSmartLabelPosition keeps label inside canvas bounds', () {
      final pos = LatexLabelPainter.computeSmartLabelPosition(
        midPoint: const Offset(5, 5),
        normalDirection: const Offset(-1, 0),
        labelSize: const Size(60, 20),
        canvasSize: const Size(800, 600),
      );

      expect(pos.dx, greaterThanOrEqualTo(8.0));
      expect(pos.dy, greaterThanOrEqualTo(8.0));
    });

    test(
      'computeSmartLabelPosition avoids component collisions when possible',
      () {
        final componentBounds = const Rect.fromLTWH(280, 150, 40, 20);
        final pos = LatexLabelPainter.computeSmartLabelPosition(
          midPoint: const Offset(300, 160),
          normalDirection: const Offset(0, -1),
          preferredOffset: 22.0,
          labelSize: const Size(50, 20),
          canvasSize: const Size(800, 600),
          componentBounds: componentBounds,
        );

        final labelRect = Rect.fromLTWH(pos.dx, pos.dy, 50, 20);
        expect(labelRect.overlaps(componentBounds), isFalse);
      },
    );
  });
}
