import 'package:flutter/material.dart';

class LightAppColors {
  static Color primary = Colors.indigo[500]!;
  static Color secondary = primary;
  static Color background = Colors.white;
  static Color dividerColor = Colors.grey[300]!;
  static Color outlineButtonBorderCol = Colors.grey[500]!;
  static Color textColor = Colors.grey[700]!;
  static Color cardColor = Colors.grey[100]!;
  static Color unSelectedNavtemColor = Colors.grey[700]!;
  static Color errorColor = Colors.red[400]!;
}

class DarkAppColors {
  static Color primary = Colors.indigo[100]!;
  static Color secondary = primary;
  static Color background = Colors.black;
  static Color dividerColor = Colors.grey[600]!;
  static Color textColor = Colors.white;
  static Color cardColor = Colors.grey[900]!;
  static Color outlineButtonBorderCol = Colors.grey[900]!;
  static Color unSelectedNavtemColor = Colors.grey[300]!;
  static Color errorColor = const Color.fromARGB(255, 255, 170, 162);
}

class ColorOperations {
  static LinearGradient shimmerGradient(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return LinearGradient(
        colors: [
          Colors.grey[800]!,
          Colors.grey[700]!,
          Colors.grey[800]!,
        ],
        stops: const [
          0.1,
          0.5,
          0.9,
        ],
      );
    } else {
      return LinearGradient(
        colors: [
          Colors.grey[300]!,
          Colors.grey[200]!,
          Colors.grey[300]!,
        ],
        stops: const [
          0.1,
          0.5,
          0.9,
        ],
      );
    }
  }
}
