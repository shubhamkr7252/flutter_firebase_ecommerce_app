import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserDatabaseConnection {
  Future<UserData?> fetchUserData({required String userId}) async {
    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.usersCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      return UserData.fromJson(documentSnapshot.data());
    } else {
      return null;
    }
  }

  Future<void> addNewCustomerData({required UserData data}) async {
    await FirestoreCollection.usersCollection.doc(data.id).set(data.toJson());
  }

  Future<void> updateCustomerNameData({required UserData userData}) async {
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
