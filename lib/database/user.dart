import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserDatabaseConnection {
  Future<UserData?> fetchUserData(
      {required String userId, required String token}) async {
    await FirestoreCollection.usersCollection.doc(userId).update({
      "tokens": FieldValue.arrayUnion([token]),
    });

    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.usersCollection.doc(userId).get();

    if (documentSnapshot.exists) {
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

  Future<void> updateUserNameData({required UserData userData}) async {
    await FirestoreCollection.usersCollection.doc(userData.id).update({
      "firstName": userData.firstName,
      "lastName": userData.lastName,
    });
  }

  Future<void> setUserProfileImage(
      {required String userId, required String imageSrc}) async {
    await FirebaseFirestore.instance.collection("Users").doc(userId).update({
      "image": imageSrc,
    });
  }
}
