import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/provider/order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/components/custom_confirmation_bottom_sheet.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/order.dart';
import '../../../theme/size.dart';
import '../../../utils/cart_color.dart';
import '../../../widgets/custom_button_a.dart';
import 'my_order_product_tile.dart';

class OrderDetailsProductDeliveryStatusTile extends StatelessWidget {
  const OrderDetailsProductDeliveryStatusTile({
    Key? key,
    required this.orderData,
    required this.orderId,
  }) : super(key: key);

  final UserOrderProductObject orderData;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderprovider, _) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          color: Theme.of(context).cardTheme.color,
        ),
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyOrderProductTile(data: orderData.productData!),
            OrderDetailsTimelineWidget(
              orderData: orderData,
              onButtonTap: () async {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Consumer<UserProvider>(
                          builder: (context, userprovider, _) =>
                              CustomConfirmationBottomSheet(
                                  title: "Cancel Order",
                                  customChild: MyOrderProductTile(
                                      data: orderData.productData!),
                                  buttonOnTap: () async {
                                    await orderprovider.cancelOrder(context,
                                        orderProductData: orderData,
                                        orderId: orderId,
                                        userId:
                                            userprovider.getCurrentUser!.id!);

                                    Navigator.of(context).pop();
                                  },
                                  buttonColor:
                                      Theme.of(context).colorScheme.error,
                                  buttonText: "Cancel Order"),
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsTimelineWidget extends StatefulWidget {
  const OrderDetailsTimelineWidget(
      {Key? key, required this.orderData, this.onButtonTap})
      : super(key: key);

  final UserOrderProductObject orderData;
  final Function? onButtonTap;

  @override
  State<OrderDetailsTimelineWidget> createState() =>
      _OrderDetailsTimelineWidgetState();
}

class _OrderDetailsTimelineWidgetState
    extends State<OrderDetailsTimelineWidget> {
  final List<String> _timelineConnectionText = [
    "Order Confirmed",
    "Shipped",
    "Out for Delivery",
    "Delivered",
    "Cancelled"
  ];
  @override
  Widget build(BuildContext context) {
    if (widget.orderData.orderData!.status! > 4) {
      throw "Order Status cannot have value more than 4";
    }
    if (widget.orderData.orderData!.status! != 4 &&
        widget.onButtonTap == null) {
      throw "ButtonOnTap must be defined if the order status is not cancelled";
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: SizeConfig.screenHeight! * .015),
        if (widget.orderData.orderData!.status != 4)
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              4,
              (index) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: SizeConfig.screenWidth! * .0475,
                          width: SizeConfig.screenWidth! * .0475,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.orderData.orderData!.status! >= index
                                ? CartColor.getColor(context)
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.25),
                          ),
                          child: index <= widget.orderData.orderData!.status!
                              ? Icon(
                                  FlutterRemix.checkbox_blank_circle_fill,
                                  size: SizeConfig.screenWidth! * .0215,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                )
                              : null,
                        ),
                        if (index != 3)
                          Container(
                            height: 20,
                            width: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    index <= widget.orderData.orderData!.status!
                                        ? (widget.orderData.orderData!
                                                        .status! ==
                                                    2 &&
                                                index == 2
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.25)
                                            : CartColor.getColor(context))
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25),
                                    index <=
                                            widget.orderData.orderData!
                                                    .status! -
                                                1
                                        ? CartColor.getColor(context)
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25)
                                  ]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth! * .025),
                  Text(
                    _timelineConnectionText[index],
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * .035,
                      fontWeight: index <= widget.orderData.orderData!.status!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          )),
        if (widget.orderData.orderData!.status! == 4)
          Flexible(
              child: Column(
            children: List.generate(2, (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: SizeConfig.screenWidth! * .0475,
                          width: SizeConfig.screenWidth! * .0475,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? CartColor.getColor(context)
                                : Theme.of(context).colorScheme.error,
                          ),
                          child: Icon(
                            FlutterRemix.checkbox_blank_circle_fill,
                            size: SizeConfig.screenWidth! * .0215,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        if (index != 1)
                          Container(
                            height: 20,
                            width: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    index <= widget.orderData.orderData!.status!
                                        ? (widget.orderData.orderData!
                                                        .status! ==
                                                    2 &&
                                                index == 2
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.25)
                                            : CartColor.getColor(context))
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25),
                                    index <=
                                            widget.orderData.orderData!
                                                    .status! -
                                                1
                                        ? CartColor.getColor(context)
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25)
                                  ]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth! * .025),
                  Text(
                    index == 0
                        ? _timelineConnectionText[0]
                        : _timelineConnectionText[4],
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * .035,
                      fontWeight: index <= widget.orderData.orderData!.status!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  )
                ],
              );
            }),
          )),
        SizedBox(height: SizeConfig.screenHeight! * .015),
        if (widget.orderData.orderData!.status! == 4)
          Text((widget.orderData.productData!.salePrice != 0
                      ? widget.orderData.productData!.salePrice
                      : widget.orderData.productData!.price)!
                  .inCurrency() +
              " has been refunded to your original payment method on " +
              DateFormat("MMM d")
                  .format(widget.orderData.orderData!.updatedAt!.toDate())),
        if (widget.orderData.orderData!.status! != 4)
          CustomButtonA(
            buttonText: "Cancel Order",
            onPress: () async {
              await widget.onButtonTap!();
            },
            textColor: Theme.of(context).colorScheme.error,
          )
      ],
    );
  }
}
