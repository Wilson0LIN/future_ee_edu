import 'package:flutter/material.dart';
import '../painters/grid_painter.dart';
import '../painters/resistor_painter.dart';
import '../painters/voltage_source_painter.dart';
import '../painters/wire_painter.dart';

/// Screen displaying the dynamic circuit canvas with 3Blue1Brown aesthetics.
class CircuitCanvasScreen extends StatelessWidget {
  const CircuitCanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Color(0xFF38BDF8),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '3b1b Series-Parallel Circuit Canvas',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background 3b1b Dot Grid
          const Positioned.fill(child: CustomPaint(painter: GridPainter())),
          // Circuit Components Layer
          Positioned.fill(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.5,
              maxScale: 2.5,
              child: SizedBox(
                width: 1200,
                height: 800,
                child: CustomPaint(painter: _SeriesParallelCircuitPainter()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeriesParallelCircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 3b1b Aesthetic Colors
    const skyBlue = Color(0xFF38BDF8);
    const neonAmber = Color(0xFFF59E0B);

    // 1. DC Voltage Source (Left)
    const vsStart = Offset(100, 160);
    const vsEnd = Offset(100, 360);
    final voltageSource = VoltageSourcePainter(
      start: vsStart,
      end: vsEnd,
      color: skyBlue,
      strokeWidth: 3.5,
      label: 'Vs (12V)',
    );
    voltageSource.paint(canvas, size);

    // 2. Wire from Voltage Source (+) to Main Series Resistor R1
    const w1 = WirePainter(
      points: [Offset(100, 160), Offset(220, 160)],
      color: skyBlue,
      strokeWidth: 3.5,
    );
    w1.paint(canvas, size);

    // 3. Main Series Resistor R1 (Top Path)
    const r1Start = Offset(220, 160);
    const r1End = Offset(380, 160);
    final r1 = ResistorPainter(
      start: r1Start,
      end: r1End,
      color: neonAmber,
      strokeWidth: 3.5,
      label: 'R1 (10Ω)',
    );
    r1.paint(canvas, size);

    // 4. Wire from R1 to Parallel Split Node
    const w2 = WirePainter(
      points: [Offset(380, 160), Offset(500, 160)],
      color: skyBlue,
      strokeWidth: 3.5,
      drawTerminalDots: true,
    );
    w2.paint(canvas, size);

    // 5. Parallel Branch 1: Top wire to R2, R2 Resistor, and Bottom wire to merge
    const wR2Top = WirePainter(
      points: [Offset(500, 160), Offset(500, 200)],
      color: skyBlue,
      strokeWidth: 3.5,
    );
    wR2Top.paint(canvas, size);

    final r2 = ResistorPainter(
      start: const Offset(500, 200),
      end: const Offset(500, 320),
      color: neonAmber,
      strokeWidth: 3.5,
      label: 'R2 (20Ω)',
    );
    r2.paint(canvas, size);

    const wR2Bottom = WirePainter(
      points: [Offset(500, 320), Offset(500, 360)],
      color: skyBlue,
      strokeWidth: 3.5,
    );
    wR2Bottom.paint(canvas, size);

    // 6. Parallel Branch 2: Extension wire to R3, R3 Resistor, and Bottom return wire
    const wR3TopExtension = WirePainter(
      points: [Offset(500, 160), Offset(660, 160), Offset(660, 200)],
      color: skyBlue,
      strokeWidth: 3.5,
      drawTerminalDots: true,
    );
    wR3TopExtension.paint(canvas, size);

    final r3 = ResistorPainter(
      start: const Offset(660, 200),
      end: const Offset(660, 320),
      color: neonAmber,
      strokeWidth: 3.5,
      label: 'R3 (20Ω)',
    );
    r3.paint(canvas, size);

    const wR3BottomExtension = WirePainter(
      points: [Offset(660, 320), Offset(660, 360), Offset(500, 360)],
      color: skyBlue,
      strokeWidth: 3.5,
      drawTerminalDots: true,
    );
    wR3BottomExtension.paint(canvas, size);

    // 7. Main Return Wire back to DC Voltage Source (-)
    const wReturn = WirePainter(
      points: [Offset(500, 360), Offset(100, 360)],
      color: skyBlue,
      strokeWidth: 3.5,
      drawTerminalDots: true,
    );
    wReturn.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
