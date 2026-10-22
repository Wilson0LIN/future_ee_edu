# Circuit Topology Rendering System - Project Guidelines

This is a Flutter application designed for custom circuit topology rendering, dynamic electron flow animation, and linear circuit solving (MNA).

## 1. Project Architecture & State Management
- Architecture Pattern: Feature-First Clean Architecture (`src/core/`, `src/features/circuit_canvas/`, `src/features/circuit_solver/`).
- State Management: `flutter_riverpod` (v2.x with Annotations).
- Immutability: Use `copyWith` pattern for domain models.

## 2. Code Style & Standards
- Formatting: Adhere strictly to official Flutter lints (`flutter analyze`). Run `flutter format .` before pushing.
- Null Safety: Strict null safety required.

## 3. CustomPaint & Rendering Guidelines
- Grid System: Render strictly on a 20px x 20px grid. Coordinates must be integer-snapped (`x = (x / 20).round() * 20`).
- Symbol Standard: Standard IEEE representations (Resistor = Zigzag Path).
- Each component class MUST expose explicit Pin coordinates: `List<Offset> get pinPositions`.

## 4. Testing & Verification Standard
- Must pass `flutter analyze` with 0 warnings/errors.
- Must run `flutter test` and pass 100% of unit tests.
