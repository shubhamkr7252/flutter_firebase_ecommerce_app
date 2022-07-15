import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserOrderDatabaseConnection {
  Future<List<UserOrderModel>> fetchUserOrdersData(
      {required String userId}) async {
    List<UserOrderModel> _list = [];

    QuerySnapshot querySnapshot = await FirestoreCollection.userOrdersCollection
        .where("uid", isEqualTo: userId)
        .get();

    if (querySnapshot.size != 0) {
      for (var element in querySnapshot.docs) {
        _list.add(UserOrderModel.fromJson(element.data()));
      }
    }

    return _list;
  }

  Future<void> addNewOrder({
    required Map<String, dynamic> orderData,
    required String orderId,
  }) async {
    await FirestoreCollection.userOrdersCollection.doc(orderId).set(orderData);
  }

  Future<void> cancelOrder(
      {required String orderId,
      required List<UserOrderProductObject> orderProductDataList}) async {
    List<Map<String, dynamic>> getOrderProductsData(
        List<UserOrderProductObject> orderProductDataList) {
      List<Map<String, dynamic>> _list = [];
      for (var element in orderProductDataList) {
        _list.add(element.toJson());
      }

      return _list;
    }

    await FirestoreCollection.userOrdersCollection.doc(orderId).update({
      "productsOrderInformation": getOrderProductsData(orderProductDataList),
    });
  }
}
