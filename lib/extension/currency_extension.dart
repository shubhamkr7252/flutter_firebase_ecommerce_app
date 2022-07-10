import 'package:intl/intl.dart';

extension LocalCurrencyFromDouble on double {
  String inCurrency() {
    return NumberFormat.currency(locale: "HI", symbol: "₹", decimalDigits: 0)
        .format(this)
        .replaceAll(".00", "")
        .replaceAll(".0", "");
  }
}

extension LocalCurrencyFromInt on int {
  String inCurrency() {
    return NumberFormat.currency(locale: "HI", symbol: "₹", decimalDigits: 0)
        .format(this);
  }
}
