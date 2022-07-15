import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';

import '../../../model/order.dart';
import '../../../theme/size.dart';
import '../../../utils/cart_color.dart';
import '../../../widgets/custom_title_chip.dart';

class OrderDetailsOrderSummaryTile extends StatelessWidget {
  const OrderDetailsOrderSummaryTile(
      {Key? key, required this.paymentData, required this.totalItems})
      : super(key: key);

  final UserOrderPaymentObject paymentData;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
      ),
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTitleChip(text: "Order Summary"),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
              Text(
                paymentData.totalAmount!.inCurrency(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Items Ordered",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
              Text(
                "x" "$totalItems",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .0325,
                  color: CartColor.getColor(context),
                ),
              ),
              Text(
                "- " + paymentData.discount!.inCurrency(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0325,
                  color: CartColor.getColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery Charge",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
              Text(
                "Free",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          const Divider(height: 1),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount Paid",
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
              Text(
                paymentData.amountPaid!.inCurrency(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0325,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
