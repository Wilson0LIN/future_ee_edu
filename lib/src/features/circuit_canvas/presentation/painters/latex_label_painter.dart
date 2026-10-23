import 'package:flutter/material.dart';

/// Painter utility for parsing LaTeX circuit notation and rendering
/// shielded, collision-avoiding text labels on the circuit canvas.
class LatexLabelPainter {
  /// Converts standard alphanumeric characters to Unicode subscript equivalents.
  static String toSubscript(String input) {
    const map = {
      '0': '₀',
      '1': '₁',
      '2': '₂',
      '3': '₃',
      '4': '₄',
      '5': '₅',
      '6': '₆',
      '7': '₇',
      '8': '₈',
      '9': '₉',
      'a': 'ₐ',
      'e': 'ₑ',
      'h': 'ₕ',
      'i': 'ᵢ',
      'j': 'ⱼ',
      'k': 'ₖ',
      'l': 'ₗ',
      'm': 'ₘ',
      'n': 'ₙ',
      'o': 'ₒ',
      'p': 'ₚ',
      'r': 'ᵣ',
      's': 'ₛ',
      't': 'ₜ',
      'u': 'ᵤ',
      'v': 'ᵥ',
      'x': 'ₓ',
      '+': '₊',
      '-': '₋',
      '=': '₌',
      '(': '₍',
      ')': '₎',
    };
    final buf = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buf.write(map[char] ?? map[char.toLowerCase()] ?? char);
    }
    return buf.toString();
  }

  /// Parses a LaTeX or raw string into an inline [TextSpan] formatted for math rendering.
  static TextSpan buildMathTextSpan(
    String rawLabel, {
    required Color color,
    double fontSize = 12.0,
  }) {
    // Trim string and remove surrounding $ delimiters if present.
    String text = rawLabel.trim();
    if (text.startsWith(r'$') && text.endsWith(r'$') && text.length >= 2) {
      text = text.substring(1, text.length - 1).trim();
    }

    // Replace common LaTeX symbol commands
    text = text
        .replaceAll(r'\Omega', 'Ω')
        .replaceAll(r'\mu', 'μ')
        .replaceAll(r'\Delta', 'Δ')
        .replaceAll(r'\,', ' ')
        .replaceAll(r'~', ' ');

    // Match \text{...} or \mathrm{...}
    final textCmdRegex = RegExp(r'\\(?:text|mathrm)\{([^}]+)\}');
    text = text.replaceAllMapped(textCmdRegex, (match) => match.group(1) ?? '');

    final spans = <TextSpan>[];
    int index = 0;

    final subscriptRegex = RegExp(
      r'([A-Za-z0-9=+–\-]+)_(\{([^}]+)\}|([A-Za-z0-9]))',
    );

    while (index < text.length) {
      final match = subscriptRegex.firstMatch(text.substring(index));
      if (match != null && match.start == 0) {
        final prefix = match.group(1) ?? '';
        final sub = match.group(3) ?? match.group(4) ?? '';

        // Add prefix with math variable styling if single letter
        final isMathVar =
            prefix.length == 1 && RegExp(r'[A-Za-z]').hasMatch(prefix);

        spans.add(
          TextSpan(
            text: prefix,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontStyle: isMathVar ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        );

        // Add subscript converted to subscript character
        spans.add(
          TextSpan(
            text: toSubscript(sub),
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        );

        index += match.end;
      } else {
        // Next chunk until match or end
        final nextIndex = match != null ? index + match.start : text.length;
        final chunk = text.substring(index, nextIndex);

        final words = chunk.split(' ');
        for (int i = 0; i < words.length; i++) {
          final word = words[i];
          final isSingleVar =
              word.length == 1 && RegExp(r'[A-Za-z]').hasMatch(word);

          spans.add(
            TextSpan(
              text: word,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontStyle: isSingleVar ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          );

          if (i < words.length - 1) {
            spans.add(
              TextSpan(
                text: ' ',
                style: TextStyle(fontSize: fontSize),
              ),
            );
          }
        }

        index = nextIndex;
      }
    }

    return TextSpan(children: spans);
  }

  /// Calculates the best label position avoiding collisions with component body
  /// and ensuring text stays within canvas boundaries.
  static Offset computeSmartLabelPosition({
    required Offset midPoint,
    required Offset normalDirection,
    required Size labelSize,
    required Size canvasSize,
    double preferredOffset = 22.0,
    Rect? componentBounds,
  }) {
    // Primary position along normal vector
    Offset labelCenter = midPoint + normalDirection * preferredOffset;

    // Check if primary position overlaps component bounds
    Rect labelRect = Rect.fromCenter(
      center: labelCenter,
      width: labelSize.width + 8.0,
      height: labelSize.height + 6.0,
    );

    if (componentBounds != null && labelRect.overlaps(componentBounds)) {
      // Try opposite direction
      final oppositeCenter = midPoint - normalDirection * preferredOffset;
      final oppositeRect = Rect.fromCenter(
        center: oppositeCenter,
        width: labelSize.width + 8.0,
        height: labelSize.height + 6.0,
      );

      if (!oppositeRect.overlaps(componentBounds)) {
        labelCenter = oppositeCenter;
        labelRect = oppositeRect;
      }
    }

    // Clamp label to stay safely within canvas boundary with 8px margin
    const double margin = 8.0;
    double left = labelCenter.dx - labelSize.width / 2;
    double top = labelCenter.dy - labelSize.height / 2;

    if (canvasSize.width > 0 && canvasSize.height > 0) {
      if (left < margin) {
        left = margin;
      } else if (left + labelSize.width > canvasSize.width - margin) {
        left = canvasSize.width - margin - labelSize.width;
      }

      if (top < margin) {
        top = margin;
      } else if (top + labelSize.height > canvasSize.height - margin) {
        top = canvasSize.height - margin - labelSize.height;
      }
    }

    return Offset(left, top);
  }

  /// Renders LaTeX formatted text with a background shield and glowing border.
  static void paintLabel({
    required Canvas canvas,
    required String rawLabel,
    required Offset midPoint,
    required Offset normalDirection,
    required Color color,
    required Size canvasSize,
    Rect? componentBounds,
    double preferredOffset = 22.0,
  }) {
    if (rawLabel.trim().isEmpty) return;

    final span = buildMathTextSpan(rawLabel, color: color);
    final textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelSize = Size(textPainter.width, textPainter.height);
    final labelPos = computeSmartLabelPosition(
      midPoint: midPoint,
      normalDirection: normalDirection,
      labelSize: labelSize,
      canvasSize: canvasSize,
      preferredOffset: preferredOffset,
      componentBounds: componentBounds,
    );

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        labelPos.dx - 4,
        labelPos.dy - 3,
        labelSize.width + 8,
        labelSize.height + 6,
      ),
      const Radius.circular(4),
    );

    // 1. Draw solid slate shield background to block grid/wire overlaps
    final bgPaint = Paint()
      ..color = const Color(0xEE0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgRect, bgPaint);

    // 2. Draw subtle glowing accent border matching component color
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(bgRect, borderPaint);

    // 3. Paint formatted LaTeX math text
    textPainter.paint(canvas, labelPos);
  }
}
