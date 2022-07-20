import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import '../model/product.dart';

class OrderProvider extends ChangeNotifier {
  List<UserOrderModel> _ordersData = [];
  bool _isDataLoaded = false;

  List<UserOrderModel> get allOrdersData => _ordersData;
  bool get isDataLoaded => _isDataLoaded;

  void resetData() {
    _ordersData.clear();
    _isDataLoaded = false;

    notifyListeners();
  }

  Future<void> fetchOrdersData({required String userId}) async {
    _ordersData =
        await UserOrderDatabaseConnection().fetchUserOrdersData(userId: userId);

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> cancelOrder(BuildContext context,
      {required String userId,
      required UserOrderProductObject orderProductData,
      required String orderId}) async {
    for (int i = 0; i < _ordersData.length; i++) {
      for (int j = 0;
          j < _ordersData[i].productsOrderInformation!.length;
          j++) {
        if (_ordersData[i].productsOrderInformation![j] == orderProductData) {
          _ordersData[i].productsOrderInformation![j].orderData!.status = 4;
          _ordersData[i].productsOrderInformation![j].orderData!.updatedAt =
              Timestamp.now();
        }
      }
    }

    await UserOrderDatabaseConnection().cancelOrder(
        orderId: orderId,
        orderProductDataList: _ordersData
            .where((element) => element.orderId == orderId)
            .first
            .productsOrderInformation!);

    NotificationProvider _notificationProvider =
        Provider.of(context, listen: false);
    await _notificationProvider.addCancelOrderNotification(
        userId: userId, productData: orderProductData.productData!);

    notifyListeners();
  }

  Future<void> placeNewOrder(
    BuildContext context, {
    required String userId,
    required PaymentSuccessResponse razorpayPaymentInformation,
    required double totalAmountPaid,
    required double delivery,
    required double totalDiscount,
    required double totalAmount,
    required UserAddressObject address,
    required List<ProductListModel> products,
  }) async {
    String orderId =
        const Uuid().v5(Uuid.NAMESPACE_X500, "$userId + ${DateTime.now()} ");

    RazorpayResponseModel _responseModel = RazorpayResponseModel.fromJson({
      "razorpay_payment_id": razorpayPaymentInformation.paymentId,
      "razorpay_signature": razorpayPaymentInformation.signature,
      "razorpay_order_id": razorpayPaymentInformation.orderId,
    });

    List<Map<String, dynamic>> listofProductsOrderToMapList(
        List<ProductListModel> data) {
      List<Map<String, dynamic>> _list = [];
      for (var element in data) {
        _list.add({
          "productData": element.toJson(),
          "orderData": {
            "updatedAt": Timestamp.now(),
            "status": 0,
          },
        });
      }

      return _list;
    }

    UserOrderModel orderData = UserOrderModel.fromJson({
      "uid": userId,
      "orderId": orderId,
      "orderCreatedAt": Timestamp.now(),
      "razorpayPaymentInformation": _responseModel.toJson(),
      "paymentInformation": {
        "amountPaid": totalAmountPaid,
        "delivery": delivery,
        "discount": totalDiscount,
        "totalAmount": totalAmount,
      },
      "address": address.toJson(),
      "productsOrderInformation": listofProductsOrderToMapList(products),
    });

    await UserOrderDatabaseConnection().addNewOrder(
      orderData: orderData.toJson(),
      orderId: orderId,
    );

    _ordersData.add(orderData);

    CartProvider _cartProvider = Provider.of(context, listen: false);
    await _cartProvider.resetData(userId: orderData.uid!);

    NotificationProvider _notificationProvider =
        Provider.of(context, listen: false);
    await _notificationProvider.addNewOrderNotification(
        orderModel: orderData, userId: orderData.uid!);

    notifyListeners();
  }
}
