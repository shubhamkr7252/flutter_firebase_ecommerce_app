import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserDatabaseConnection {
  Future<UserData?> fetchUserData({
    required String userId,
    required String token,
  }) async {
    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.usersCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      await FirestoreCollection.usersCollection.doc(userId).update({
        "tokens": FieldValue.arrayUnion([token]),
      });
      return UserData.fromJson(documentSnapshot.data());
    } else {
      return null;
    }
  }

  Future<void> removeTokenData(
      {required String userId, required String token}) async {
    await FirestoreCollection.usersCollection.doc(userId).update({
      "tokens": FieldValue.arrayRemove([token]),
    });
  }

  Future<List<String>> fetchUserTokenData({required String userId}) async {
    List<String> _userDeviceTokens = [];

    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.usersCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      for (var element in documentSnapshot.get("tokens")) {
        _userDeviceTokens.add(element);
      }
    }

    return _userDeviceTokens;
  }

  Future<void> addNewUserData({required UserData data}) async {
    await FirestoreCollection.usersCollection.doc(data.id).set(data.toJson());
  }

  Future<void> updateUserData({required UserData userData}) async {
    await FirestoreCollection.usersCollection.doc(userData.id).update({
      "firstName": userData.firstName,
      "lastName": userData.lastName,
      "email": userData.email,
    });
  }

  Future<void> setUserProfileImage(
      {required String userId, required String imageSrc}) async {
    await FirebaseFirestore.instance.collection("Users").doc(userId).update({
      "image": imageSrc,
    });
  }

  Future<void> deleteUserAccount(BuildContext context,
      {required String userId}) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    WriteBatch _batch = _db.batch();

    await FirestoreCollection.usersCollection.doc(userId).delete();

    DocumentSnapshot _cartDoc =
        await FirestoreCollection.userCartCollection.doc(userId).get();
    if (_cartDoc.exists) {
      _batch.delete(FirestoreCollection.userCartCollection.doc(userId));
    }

    DocumentSnapshot _addressDoc =
        await FirestoreCollection.userAddressCollection.doc(userId).get();
    if (_addressDoc.exists) {
      _batch.delete(FirestoreCollection.userAddressCollection.doc(userId));
    }

    DocumentSnapshot _notificationDoc =
        await FirestoreCollection.userNotificationCollection.doc(userId).get();
    if (_notificationDoc.exists) {
      _batch.delete(FirestoreCollection.userNotificationCollection.doc(userId));
    }

    DocumentSnapshot _wishlistDoc =
        await FirestoreCollection.userWishlistCollection.doc(userId).get();
    if (_wishlistDoc.exists) {
      _batch.delete(FirestoreCollection.userWishlistCollection.doc(userId));
    }

    _batch.commit();
  }
}
