import 'package:flutter/material.dart';

class CartColor {
  static Color getColor(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return Colors.lightGreen[300]!;
    } else {
      return Colors.lightGreen[800]!;
    }
  }
}
