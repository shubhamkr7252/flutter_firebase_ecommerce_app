import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/utils/cart_color.dart';
import '../../../theme/size.dart';

class MoneySavedTile extends StatelessWidget {
  const MoneySavedTile({
    Key? key,
    required this.discount,
  }) : super(key: key);

  final double discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth!,
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      decoration: BoxDecoration(
        color: CartColor.getColor(context).withOpacity(0.225),
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .015),
      ),
      child: Text(
        "You will save ${discount.inCurrency()} on this order",
        style: TextStyle(
          color: CartColor.getColor(context),
          fontSize: SizeConfig.screenWidth! * .035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
