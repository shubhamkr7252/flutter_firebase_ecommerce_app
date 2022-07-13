import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../provider/order_provider.dart';
import '../../utils/cart_color.dart';

class OrderPlacedSuccessScreen extends StatefulWidget {
  const OrderPlacedSuccessScreen(
      {Key? key,
      required this.totalItems,
      required this.totalAmountPaid,
      required this.totalDiscount,
      required this.razorpayResponseModel,
      required this.userId,
      required this.products,
      required this.selectedAddress,
      required this.totalAmount,
      required this.orderId})
      : super(key: key);

  final int totalItems;
  final double totalAmount;
  final double totalDiscount;
  final double totalAmountPaid;
  final PaymentSuccessResponse razorpayResponseModel;
  final String userId, orderId;
  final List<ProductListModel> products;
  final UserAddressObject selectedAddress;

  @override
  State<OrderPlacedSuccessScreen> createState() =>
      _OrderPlacedSuccessScreenState();
}

class _OrderPlacedSuccessScreenState extends State<OrderPlacedSuccessScreen>
    with TickerProviderStateMixin {
  late OrderProvider _orderProvider;

  late ValueNotifier<bool> _isOrderProcessing;

  @override
  void initState() {
    _orderProvider = Provider.of(context, listen: false);

    _isOrderProcessing = ValueNotifier(true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _orderProvider.placeNewOrder(context,
          userId: widget.userId,
          razorpayPaymentInformation: widget.razorpayResponseModel,
          totalAmountPaid: widget.totalAmountPaid,
          delivery: 0,
          totalDiscount: widget.totalDiscount,
          totalAmount: widget.totalAmount,
          address: widget.selectedAddress,
          products: widget.products);
      _isOrderProcessing.value = false;
    });

    super.initState();
  }

  @override
  void dispose() {
    _isOrderProcessing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isOrderProcessing,
      builder: (context, value, child) => WillPopScope(
        onWillPop: () async {
          return !value;
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: value
                ? Theme.of(context).colorScheme.primary
                : CartColor.getColor(context),
            statusBarIconBrightness:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                color: Theme.of(context).colorScheme.background,
                width: SizeConfig.screenWidth!,
                height: SizeConfig.screenHeight!,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: value
                                    ? Theme.of(context).colorScheme.primary
                                    : CartColor.getColor(context),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        SizeConfig.screenHeight! * .01),
                                    bottomRight: Radius.circular(
                                        SizeConfig.screenHeight! * .01)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.screenHeight! * .035,
                                  right: SizeConfig.screenHeight! * .25,
                                  top: SizeConfig.screenHeight! * .045,
                                  bottom: SizeConfig.screenHeight! * .045,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        shape: BoxShape.circle,
                                      ),
                                      height: SizeConfig.screenHeight! * .065,
                                      width: SizeConfig.screenHeight! * .05,
                                      child: value
                                          ? CustomLoader(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: SizeConfig.screenHeight! *
                                                  .025,
                                            )
                                          : Icon(
                                              FlutterRemix.check_fill,
                                              size: SizeConfig.screenHeight! *
                                                  .025,
                                              color:
                                                  CartColor.getColor(context),
                                            ),
                                    ),
                                    SizedBox(
                                        height: SizeConfig.screenHeight! * .01),
                                    Text(
                                      value
                                          ? "Processing your order"
                                          : "Order Placed Successfully",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .045),
                                    ),
                                    SizedBox(
                                        height: SizeConfig.screenHeight! * .01),
                                    Text(
                                      value
                                          ? "Confirmation will be sent after order has been processed."
                                          : "The order confirmation has been sent to your email address.",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontSize:
                                              SizeConfig.screenWidth! * .035),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.screenHeight! * .035),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.screenHeight! * .03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Details",
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth! * .05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .015),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Amount",
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                      Text(
                                        widget.totalAmount.inCurrency(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Items Ordered",
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                      Text(
                                        "x" "${widget.totalItems}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Discount",
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                          color: CartColor.getColor(context),
                                        ),
                                      ),
                                      Text(
                                        "- " +
                                            widget.totalDiscount.inCurrency(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                          color: CartColor.getColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Delivery Charge",
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                      Text(
                                        "Free",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .015),
                                  const Divider(height: 1),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .015),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Amount Paid",
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                      Text(
                                        widget.totalAmountPaid.inCurrency(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth! * .0325,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (value == false)
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * .035),
                                  if (value == false)
                                    Text(
                                      "Thanks for shopping with us!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.screenWidth! * .0325,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.screenHeight! * .035),
                          ],
                        ),
                      ),
                    ),
                    if (value == false)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenHeight! * .015),
                        child: CustomButtonA(
                            buttonText: "Back to browse",
                            onPress: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
