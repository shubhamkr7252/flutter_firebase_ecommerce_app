import 'package:flutter/widgets.dart';

class FormValidator {
  static bool validate({required GlobalKey<FormState> key}) {
    final form = key.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
