import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/notification.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class NotificationDatabaseConnection {
  Future<List<NotificationModel>> getNotificationData(
      {required String userId}) async {
    List<NotificationModel> _list = [];

    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.userNotificationCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      for (var element in documentSnapshot.get("notifications")) {
        _list.add(NotificationModel.fromJson(element));
      }
    }
    return _list;
  }

  Future<void> updateNotificationData(
      {required String userId,
      required List<NotificationModel> notificationData}) async {
    List<Map<String, dynamic>> _list = [];

    for (NotificationModel element in notificationData) {
      _list.add(element.toJson());
    }

    await FirestoreCollection.userNotificationCollection.doc(userId).set({
      "notifications": _list,
      "uid": userId,
    });
  }
}
