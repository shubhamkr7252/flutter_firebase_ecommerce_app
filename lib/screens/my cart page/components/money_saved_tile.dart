import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
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
        color: (MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.green[300]
                : Colors.green)!
            .withOpacity(0.225),
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .015),
      ),
      child: Text(
        "You will save ${discount.inCurrency()} on this order",
        style: TextStyle(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.green[300]
              : Colors.green,
          fontSize: SizeConfig.screenWidth! * .035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
