import 'package:flutter/material.dart';
import 'src/features/circuit_canvas/presentation/circuit_canvas_screen.dart';

void main() {
  runApp(const CircuitApp());
}

class CircuitApp extends StatelessWidget {
  const CircuitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circuit Topology Canvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const CircuitCanvasScreen(),
    );
  }
}
