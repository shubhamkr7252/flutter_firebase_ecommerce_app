import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/database/notification.dart';
import 'package:flutter_firebase_ecommerce_app/model/notification.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _allNotificationData = [];
  bool _isDataLoaded = false;

  List<NotificationModel> get allNotificationData => _allNotificationData;
  bool get isDataLoaded => _isDataLoaded;

  updateNotificationTimeData() {
    notifyListeners();
  }

  Future<void> fetchNotificationData({required String userId}) async {
    _allNotificationData = await NotificationDatabaseConnection()
        .getNotificationData(userId: userId);

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> clearNotification({required String userId}) async {
    _allNotificationData.clear();

    await NotificationDatabaseConnection().updateNotificationData(
        userId: userId, notificationData: _allNotificationData);

    notifyListeners();
  }

  Future<void> addNewOrderNotification(
      {required String userId, required UserOrderModel orderModel}) async {
    List<String> _productNameList = [];
    List<String> _productImagesist = [];

    for (UserOrderProductObject element
        in orderModel.productsOrderInformation!) {
      _productNameList.add(element.productData!.name!);
      _productImagesist.add(element.productData!.images!.first);
    }

    String _notificationDescription = "Your order containing " +
        _productNameList.first +
        (_productNameList.length != 1
            ? " and " +
                (_productNameList.length - 1).toString() +
                " more " +
                (_productNameList.length - 1 == 1 ? "product" : "products")
            : "") +
        " has been confirmed.";

    NotificationModel _newNotification = NotificationModel.fromJson({
      "title": "Order Confirmed",
      "description": _notificationDescription,
      "images": _productImagesist,
      "createdAt": Timestamp.now()
    });

    _allNotificationData.add(_newNotification);

    await NotificationDatabaseConnection().updateNotificationData(
        userId: userId, notificationData: _allNotificationData);

    notifyListeners();
  }

  Future<void> addCancelOrderNotification(
      {required String userId, required ProductListModel productData}) async {
    String _notificationDescription =
        "Your order containing " + productData.name! + " has been cancelled.";

    NotificationModel _newNotification = NotificationModel.fromJson({
      "title": "Order Cancelled",
      "description": _notificationDescription,
      "images": [productData.images!.first],
      "createdAt": Timestamp.now()
    });

    _allNotificationData.add(_newNotification);

    await NotificationDatabaseConnection().updateNotificationData(
        userId: userId, notificationData: _allNotificationData);

    notifyListeners();
  }
}
