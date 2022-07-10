import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_firebase_ecommerce_app/model/cart.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/cart_bottom_price_container.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/cart_top_address_widget.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/money_saved_tile.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20listing%20page/components/product_list_tile.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import '../../../service/razorpay_integration.dart';
import '../../../theme/size.dart';
import '../my_cart.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key? key,
    required this.cartData,
    required this.discount,
    required this.totalAmount,
    required this.userId,
    required this.defaultAddress,
  }) : super(key: key);

  final CartModel cartData;
  final double discount, totalAmount;
  final String userId;
  final UserAddressObject defaultAddress;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _currentTab;

  late UserOrderProvider _orderProvider;

  late Razorpay _razorpay;

  late String? _globalOrderId;

  @override
  void initState() {
    _currentTab = ValueNotifier<int>(0);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _currentTab.value = _tabController.index;
    });

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    RazorpayResponseModel _responseModle =
        RazorpayResponseModel.fromJson(response);
    _orderProvider = Provider.of(context, listen: false);
    await _orderProvider.placeNewOrder(context,
        userId: widget.userId,
        razorpayResponseData: _responseModle,
        orderId: _responseModle.orderId!,
        products: widget.cartData.products!,
        totalAmount: widget.totalAmount,
        address: widget.defaultAddress);

    Navigator.of(context).pop(true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CartResponseWidget(
              title: "Oops! Payment failed",
              description: "Please retry or use another payment method.",
              lottieSrc: "assets/lottie_files/error_lottie.json",
              negativeButtonText: "Cancel",
              buttonText: "Retry",
              buttonOnTap: () async {
                Navigator.of(context).pop();
                await RazorpayIntegration().makePayment(context,
                    totalAmount: (widget.totalAmount * 100).toDouble(),
                    orderId: _globalOrderId!,
                    razorpay: _razorpay);
              },
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log(response.walletName!);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index == 1) {
          _tabController.animateTo(0);
          return false;
        } else {
          return true;
        }
      },
      child: CustomScaffold(
          title: "Place Order",
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: const CartTopAddressWidget(hideButton: true)),
              Expanded(
                child: PlaceOrderSummaryScreen(
                    cartData: widget.cartData,
                    discount: widget.discount,
                    totalAmount: widget.totalAmount),
              ),
              Consumer<UserProvider>(
                builder: (context, userprovider, _) => CartBottomPriceContainer(
                    totalCost: widget.totalAmount,
                    buttonOnTap: () async {
                      OrderIdRequestModel orderData =
                          OrderIdRequestModel.fromJson({
                        "amount": (widget.totalAmount * 100).toDouble(),
                        "currency": "INR",
                        "receipt": const Uuid()
                            .v5(Uuid.NAMESPACE_DNS,
                                "${userprovider.getCurrentUser!.id} + ${DateTime.now()}")
                            .toString()
                      });

                      OrderIdResponseModel? orderReponseData =
                          await RazorpayIntegration()
                              .getOrderId(orderData: orderData);

                      if (orderReponseData != null) {
                        _globalOrderId = orderReponseData.id!;

                        await RazorpayIntegration().makePayment(context,
                            totalAmount: (widget.totalAmount * 100).toDouble(),
                            orderId: orderReponseData.id!,
                            razorpay: _razorpay);
                      }
                    },
                    buttonText: "Pay Now"),
              ),
            ],
          )),
    );
  }
}

class PlaceOrderSummaryScreen extends StatelessWidget {
  const PlaceOrderSummaryScreen({
    Key? key,
    required this.cartData,
    required this.discount,
    required this.totalAmount,
  }) : super(key: key);

  final CartModel cartData;
  final double discount, totalAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (discount != 0)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .015),
                child: MoneySavedTile(discount: discount),
              ),
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                      padding: index == 0
                          ? EdgeInsets.only(
                              top: SizeConfig.screenHeight! * .015)
                          : (index == cartData.products!.length - 1
                              ? EdgeInsets.only(
                                  bottom: SizeConfig.screenHeight! * .015)
                              : EdgeInsets.zero),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenHeight! * .01),
                        ),
                        padding:
                            EdgeInsets.all(SizeConfig.screenHeight! * .015),
                        child: ProductListTile(data: cartData.products![index]),
                      ),
                    ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                itemCount: cartData.products!.length),
          ],
        ),
      ),
    );
  }
}
