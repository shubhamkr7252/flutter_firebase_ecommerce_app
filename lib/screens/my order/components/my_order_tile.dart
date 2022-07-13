import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:jiffy/jiffy.dart';
import '../../../widgets/custom_title_chip.dart';
import 'my_order_product_tile.dart';

class MyOrderTile extends StatelessWidget {
  const MyOrderTile({Key? key, required this.orderData, required this.onTap})
      : super(key: key);

  final UserOrderModel orderData;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        color: Theme.of(context).cardTheme.color,
      ),
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitleChip(
              text: Jiffy(orderData.orderCreatedAt!.toDate())
                  .format("do MMM yy")),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => MyOrderProductTile(
                    data:
                        orderData.productsOrderInformation![index].productData!,
                    orderStatus: orderData
                        .productsOrderInformation![index].orderData!.status!,
                  ),
              separatorBuilder: (context, index) =>
                  SizedBox(height: SizeConfig.screenHeight! * .015),
              itemCount: orderData.productsOrderInformation!.length),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(TextSpan(
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .035),
                children: [
                  const TextSpan(text: "Total Amount: "),
                  TextSpan(
                      text: orderData.paymentInformation!.amountPaid!
                          .inCurrency(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              )),
              Text.rich(TextSpan(
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .035),
                children: [
                  const TextSpan(text: "Quantity: "),
                  TextSpan(
                      text:
                          orderData.productsOrderInformation!.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              )),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          CustomButtonA(
              buttonText: "Show Details",
              onPress: () {
                onTap();
              }),
        ],
      ),
    );
  }
}
