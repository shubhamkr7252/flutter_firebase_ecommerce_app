import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';

class UserOrderProvider extends ChangeNotifier {
  UserAddressesModel? _addressesData;
  final bool _isDataLoaded = true;

  UserAddressesModel? get allAddressesData => _addressesData;
  bool get isDataLoaded => _isDataLoaded;

  Future<void> placeNewOrder(
    BuildContext context, {
    required String userId,
    required RazorpayResponseModel razorpayResponseData,
    required String orderId,
    required List<ProductListModel> products,
    required double totalAmount,
    required UserAddressObject address,
  }) async {
    await OrderDatabaseConnection().addNewOrder(
        userId: userId,
        razorpayResponseData: razorpayResponseData,
        orderId: orderId,
        products: products,
        totalAmount: totalAmount,
        address: address);
    CartProvider _cartProvider = Provider.of(context, listen: false);
    await _cartProvider.resetData(userId: userId);

    notifyListeners();
  }
}
