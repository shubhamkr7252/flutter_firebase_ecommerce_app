class DiscountCalculator {
  static String calculateDiscount(String salePrice, String regularPrice) {
    var result =
        (((double.parse(salePrice) / double.parse(regularPrice)) * 100) - 100)
            .abs()
            .toInt();
    return result.toString() + "%";
  }
}
