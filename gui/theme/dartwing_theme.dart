import 'package:flutter/material.dart';

class DartwingTheme extends ThemeExtension<DartwingTheme> {
  const DartwingTheme({
    required this.backgroundColor,
    required this.lightBackgroundColor,
  });

  final Color backgroundColor;
  final Color lightBackgroundColor;

  static const defaultTheme = DartwingTheme(
    backgroundColor: Colors.white,
    lightBackgroundColor: Colors.white24,
  );

  static DartwingTheme of(BuildContext context) {
    return Theme.of(context).extension<DartwingTheme>() ?? defaultTheme;
  }

  @override
  DartwingTheme copyWith({
    Color? backgroundColor,
    Color? lightBackgroundColor,
  }) {
    return DartwingTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      lightBackgroundColor: lightBackgroundColor ?? this.lightBackgroundColor,
    );
  }

  @override
  DartwingTheme lerp(covariant ThemeExtension<DartwingTheme>? other, double t) {
    if (other is! DartwingTheme) {
      return this;
    }
    return DartwingTheme(
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
              backgroundColor,
      lightBackgroundColor:
          Color.lerp(lightBackgroundColor, other.lightBackgroundColor, t) ??
              lightBackgroundColor,
    );
  }
}
