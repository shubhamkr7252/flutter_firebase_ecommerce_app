import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_firebase_ecommerce_app/model/cart.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import '../../service/razorpay_integration.dart';
import '../../theme/size.dart';
import '../product listing/components/product_list_tile.dart';
import 'components/cart_bottom_price_container.dart';
import 'components/cart_top_address_widget.dart';
import 'components/money_saved_tile.dart';
import 'my_cart_screen.dart';
import 'order_placed_success_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key? key,
    required this.cartData,
    required this.discount,
    required this.totalAmount,
    required this.totalAmountPaid,
    required this.userId,
    required this.defaultAddress,
  }) : super(key: key);

  final CartModel cartData;
  final double discount, totalAmount, totalAmountPaid;
  final String userId;
  final UserAddressObject defaultAddress;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
    with TickerProviderStateMixin {
  late ValueNotifier<int> _currentTab;

  late Razorpay _razorpay;

  late String? _globalOrderId;

  @override
  void initState() {
    _currentTab = ValueNotifier<int>(0);

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    NavigatorService.pushReplace(context,
        page: OrderPlacedSuccessScreen(
          totalItems: widget.cartData.products!.length,
          totalAmount: widget.totalAmount,
          totalDiscount: widget.discount,
          razorpayResponseModel: response,
          userId: widget.userId,
          products: widget.cartData.products!,
          selectedAddress: widget.defaultAddress,
          totalAmountPaid: widget.totalAmountPaid,
          orderId: response.orderId!,
        ));
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
                    totalAmount: (widget.totalAmountPaid * 100).toDouble(),
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
    return CustomScaffold(
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
                  totalAmount: widget.totalAmountPaid),
            ),
            Consumer<UserProvider>(
              builder: (context, userprovider, _) => CartBottomPriceContainer(
                  toalAmountPaid: widget.totalAmountPaid,
                  buttonOnTap: () async {
                    OrderIdRequestModel orderData =
                        OrderIdRequestModel.fromJson({
                      "amount": (widget.totalAmountPaid * 100).toDouble(),
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
                          totalAmount:
                              (widget.totalAmountPaid * 100).toDouble(),
                          orderId: orderReponseData.id!,
                          razorpay: _razorpay);
                    }
                  },
                  buttonText: "Pay Now"),
            ),
          ],
        ));
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
