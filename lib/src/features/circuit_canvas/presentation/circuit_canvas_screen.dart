import 'package:flutter/material.dart';

import 'painters/grid_painter.dart';
import 'painters/resistor_painter.dart';
import 'painters/voltage_source_painter.dart';
import 'painters/wire_painter.dart';

/// Screen displaying interactive or structured circuit topology on a grid canvas.
class CircuitCanvasScreen extends StatelessWidget {
  const CircuitCanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBackgroundColor = Color(0xFF0F172A); // Slate 900
    const gridLineColor = Color(0xFF1E293B); // Slate 800
    const brightAccentColor = Color(0xFF38BDF8); // Sky Blue (#38BDF8)
    const amberAccentColor = Color(0xFFF59E0B); // Amber

    // Coordinates snapped to 20px grid
    const v1Start = Offset(100, 100);
    const v1End = Offset(100, 260);

    const r1Start = Offset(180, 100);
    const r1End = Offset(300, 100);

    const r2Start = Offset(420, 140);
    const r2End = Offset(540, 140);

    const r3Start = Offset(420, 220);
    const r3End = Offset(540, 220);

    // 90-degree orthogonal connecting wire paths
    final w1 = [v1Start, r1Start];
    final w2 = [r1End, const Offset(380, 100)];
    final w3 = [const Offset(380, 100), const Offset(380, 140), r2Start];
    final w4 = [const Offset(380, 100), const Offset(380, 220), r3Start];
    final w5 = [r2End, const Offset(580, 140), const Offset(580, 260)];
    final w6 = [r3End, const Offset(580, 220), const Offset(580, 260)];
    final w7 = [const Offset(580, 260), v1End];

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Circuit Topology Canvas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
      ),
      body: Stack(
        children: [
          // Background Grid
          CustomPaint(
            size: Size.infinite,
            painter: const GridPainter(
              gridSize: 20.0,
              gridColor: gridLineColor,
              strokeWidth: 1.0,
            ),
          ),

          // Wire Connections
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w1,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w2,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w3,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w4,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w5,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w6,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: WirePainter(
              points: w7,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),

          // Voltage Source V1
          CustomPaint(
            size: Size.infinite,
            painter: const VoltageSourcePainter(
              start: v1Start,
              end: v1End,
              label: 'V1 (12V)',
              color: amberAccentColor,
              strokeWidth: 3.0,
            ),
          ),

          // Series Resistor R1
          CustomPaint(
            size: Size.infinite,
            painter: const ResistorPainter(
              start: r1Start,
              end: r1End,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),

          // Parallel Resistor R2
          CustomPaint(
            size: Size.infinite,
            painter: const ResistorPainter(
              start: r2Start,
              end: r2End,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),

          // Parallel Resistor R3
          CustomPaint(
            size: Size.infinite,
            painter: const ResistorPainter(
              start: r3Start,
              end: r3End,
              color: brightAccentColor,
              strokeWidth: 3.0,
            ),
          ),

          // Text Labels Overlay for Circuit Components
          const _ComponentLabel(
            position: Offset(210, 70),
            text: 'R1 (Series: 100 Ω)',
          ),
          const _ComponentLabel(
            position: Offset(450, 110),
            text: 'R2 (Parallel: 200 Ω)',
          ),
          const _ComponentLabel(
            position: Offset(450, 190),
            text: 'R3 (Parallel: 200 Ω)',
          ),
          const _ComponentLabel(position: Offset(30, 170), text: 'V1 (12V)'),

          // Info Overlay Box
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: brightAccentColor.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Topology: Series-Parallel Circuit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Grid: 20px x 20px | Orthogonal 90° Wires',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentLabel extends StatelessWidget {
  final Offset position;
  final String text;

  const _ComponentLabel({required this.position, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE2E8F0),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
