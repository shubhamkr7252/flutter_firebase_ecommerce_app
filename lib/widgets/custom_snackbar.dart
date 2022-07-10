import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context,
      {required String content,
      bool? floating,
      Color? bgColor,
      Duration? duration,
      SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration ?? const Duration(seconds: 1),
      action: action,
      content: Text(
        content,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyText1!.color!),
      ),
      behavior:
          floating == true ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      backgroundColor: bgColor ?? Theme.of(context).colorScheme.background,
    ));
  }
}
