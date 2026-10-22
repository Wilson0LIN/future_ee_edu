# Circuit Topology Rendering System - Project Guidelines

This is a Flutter application designed for custom circuit topology rendering, dynamic electron flow animation, and linear circuit solving (MNA).

---

## 1. Project Architecture & State Management

- **Architecture Pattern**: Feature-First Clean Architecture.
  - Directory structure under `lib/`:
    - `src/core/`: Common utilities, themes, constants, math solvers.
    - `src/features/circuit_canvas/`: UI, painters, domain models, and state management for rendering.
    - `src/features/circuit_solver/`: Circuit topological models, matrices, and Modified Nodal Analysis (MNA).
- **State Management**: `flutter_riverpod` (v2.x with Annotations / Code Generator `riverpod_generator`).
- **Immutability**: Use `freezed` or plain `copyWith` pattern for domain models (e.g., `ComponentNode`, `NetLine`).

---

## 2. Code Style & Standards

- **Formatting**: Adhere strictly to official Flutter lints (`flutter analyze`). Run `flutter format .` before pushing.
- **Null Safety**: Strict null safety required. Avoid `!` force-unwraps unless covered by unit tests.
- **Naming Conventions**:
  - Files: `snake_case.dart`
  - Classes: `PascalCase`
  - Variables/Methods: `camelCase`
- **Documentation**: Provide clear inline docstrings (`///`) for complex math calculations and custom rendering algorithms.

---

## 3. CustomPaint & Rendering Guidelines

All circuit rendering takes place in `CustomPaint` / `CustomPainter` layers.

- **Grid System**:
  - Render strictly on a 20px x 20px grid. Coordinates must be integer-snapped (`x = (x / 20).round() * 20`).
  - Do not hardcode pixel sizes without multiplying or snapping to grid constants.
- **Paint Operations**:
  - Separate static background canvas (grid lines, wires) from animated foreground canvas (moving electrons, highlighted nodes).
  - All electron animations must consume an `animationValue` (range `0.0` to `1.0`) passed from an `AnimationController`.
  - Use `PathMetrics` (`path.computeMetrics()`) for sampling positions (`getTangentForOffset`) along complex wires.
  - Apply `MaskFilter.blur(BlurStyle.normal, r)` for glow effects on selected nodes and electrons.
- **Symbol Standard**:
  - Standard IEEE/IEC representations (Resistor = Zigzag Path, Capacitor = Parallel lines, Voltage Source = Circle with +/-).
  - Each component class MUST expose explicit Pin coordinates: `List<Offset> get pinPositions`.

---

## 4. Testing & Verification Standard

Jules must verify every pull request against these automated checks:

- **Analysis & Formatting**:
  - Must pass `flutter analyze` with 0 warnings/errors.
- **Unit & Widget Tests**:
  - Must run `flutter test` and pass 100% of tests.
  - **CustomPaint Tests**: Ensure `CustomPainter` logic (e.g., path generation, pin calculation) is isolated from UI widget trees so it can be verified via pure Dart unit tests.
  - **Matrix Solver Tests**: All MNA matrix equations must be tested against reference values (e.g., voltage divider, parallel resistor calculations).

---

## 5. Agent Instructions for Tasks

When implementing new features or components:
1. Create models under `domain/`, logic/notifiers under `presentation/controllers/`, and painters under `presentation/painters/`.
2. Do not introduce monolithic God-classes. Keep `CustomPainter` classes small and modular (e.g., `ResistorPainter`, `WirePainter`).
3. Always update or add corresponding unit tests under `test/` for any new solver logic or path math.
