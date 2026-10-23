import 'package:flutter/material.dart';

import '../painters/component_orientation.dart';
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

    // 1. DC Voltage Source (Left Branch)
    final voltageSource = VoltageSourcePainter.fromCenter(
      center: const Offset(100, 260),
      orientation: ComponentOrientation.deg90,
      length: 200.0,
      color: skyBlue,
      strokeWidth: 3.5,
      label: r'$V_s = 12\,\text{V}$',
      drawTerminalDots: true,
    );
    voltageSource.paint(canvas, size);

    // 2. Wire from Voltage Source (+) (100, 160) to Main Series Resistor R1 (220, 160)
    const w1 = WirePainter(
      points: [Offset(100, 160), Offset(220, 160)],
      color: skyBlue,
      strokeWidth: 3.5,
    );
    w1.paint(canvas, size);

    // 3. Main Series Resistor R1 (Top Path)
    final r1 = ResistorPainter.fromCenter(
      center: const Offset(300, 160),
      orientation: ComponentOrientation.deg0,
      length: 160.0,
      color: neonAmber,
      strokeWidth: 3.5,
      label: r'$R_1 = 10\,\Omega$',
      drawTerminalDots: true,
    );
    r1.paint(canvas, size);

    // 4. Wire from R1 (380, 160) to Parallel Split Node (500, 160)
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

    final r2 = ResistorPainter.fromCenter(
      center: const Offset(500, 260),
      orientation: ComponentOrientation.deg90,
      length: 120.0,
      color: neonAmber,
      strokeWidth: 3.5,
      label: r'$R_2 = 20\,\Omega$',
      drawTerminalDots: true,
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

    final r3 = ResistorPainter.fromCenter(
      center: const Offset(660, 260),
      orientation: ComponentOrientation.deg90,
      length: 120.0,
      color: neonAmber,
      strokeWidth: 3.5,
      label: r'$R_3 = 20\,\Omega$',
      drawTerminalDots: true,
    );
    r3.paint(canvas, size);

    const wR3BottomExtension = WirePainter(
      points: [Offset(660, 320), Offset(660, 360), Offset(500, 360)],
      color: skyBlue,
      strokeWidth: 3.5,
      drawTerminalDots: true,
    );
    wR3BottomExtension.paint(canvas, size);

    // 7. Main Return Wire back to DC Voltage Source (-) (100, 360)
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
