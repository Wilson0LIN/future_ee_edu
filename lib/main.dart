import 'package:flutter/material.dart';
import 'src/features/circuit_canvas/presentation/screens/circuit_canvas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3b1b Circuit Topology Canvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          surface: Color(0xFF0F172A),
        ),
        useMaterial3: true,
      ),
      home: const CircuitCanvasScreen(),
    );
  }
}
