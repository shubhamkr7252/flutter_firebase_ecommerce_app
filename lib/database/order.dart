import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class OrderDatabaseConnection {
  Future<void> addNewOrder({
    required String userId,
    required RazorpayResponseModel razorpayResponseData,
    required String orderId,
    required List<ProductListModel> products,
    required double totalAmount,
    required UserAddressObject address,
  }) async {
    List<Map<String, dynamic>> _productsMapList = [];
    for (var element in products) {
      _productsMapList.add(element.toJson());
    }

    Map<String, dynamic> _addressDataWithoutId = address.toJson();
    _addressDataWithoutId.removeWhere((key, value) => key == "addressId");

    await FirestoreCollection.userOrdersCollection.doc(orderId).set({
      "products": _productsMapList,
      "totalAmount": totalAmount,
      "orderId": orderId,
      "paymentInformation": razorpayResponseData.toJson(),
      "address": _addressDataWithoutId,
      "uid": userId,
    });
  }
}
