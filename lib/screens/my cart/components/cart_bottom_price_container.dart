import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/cart_color.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';

class CartBottomPriceContainer extends StatelessWidget {
  const CartBottomPriceContainer({
    Key? key,
    required this.toalAmountPaid,
    required this.buttonOnTap,
    required this.buttonText,
  }) : super(key: key);

  final double toalAmountPaid;
  final Function buttonOnTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(0.25),
              blurRadius: 2.0,
            ),
          ],
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.screenHeight! * .01),
              topRight: Radius.circular(SizeConfig.screenHeight! * .01))),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight! * .015,
          vertical: SizeConfig.screenHeight! * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toalAmountPaid.inCurrency().replaceAll(".0", ""),
                  style: TextStyle(fontSize: SizeConfig.screenWidth! * .045),
                ),
                Text(
                  "+ Free Delivery",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: SizeConfig.screenWidth! * .03,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: CustomButtonA(
                textColor: CartColor.getColor(context),
                buttonText: buttonText,
                width: SizeConfig.screenWidth! * .35,
                onPress: () async {
                  await buttonOnTap();
                }),
          ),
        ],
      ),
    );
  }
}
