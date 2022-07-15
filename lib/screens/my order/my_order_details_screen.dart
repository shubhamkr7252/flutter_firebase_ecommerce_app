import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:jiffy/jiffy.dart';

import '../../widgets/custom_title_chip.dart';
import 'components/order_details_order_summary_tile.dart';
import 'components/order_details_product_delivery_status_tile.dart';

class MyOrderDetailsScreen extends StatelessWidget {
  const MyOrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

  final UserOrderModel orderData;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Order Details",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitleChip(
                  text: "Order No: " + orderData.orderId!.toUpperCase()),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              CustomTitleChip(
                  text: Jiffy(orderData.orderCreatedAt!.toDate())
                      .format("do MMM yy")),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) =>
                      OrderDetailsProductDeliveryStatusTile(
                        orderData: orderData.productsOrderInformation![index],
                        orderId: orderData.orderId!,
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                  itemCount: orderData.productsOrderInformation!.length),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              OrderDetailsOrderSummaryTile(
                paymentData: orderData.paymentInformation!,
                totalItems: orderData.productsOrderInformation!.length,
              ),
              SizedBox(height: SizeConfig.screenHeight! * .015),
            ],
          ),
        ),
      ),
    );
  }
}
