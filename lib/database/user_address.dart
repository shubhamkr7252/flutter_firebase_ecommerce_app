import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class AddressDatabaseOperations {
  Future<void> addNewAddress(
      Map<String, Map<String, dynamic>> data, UserData _currentUser) async {
    FirestoreCollection.userAddressCollection
        .doc(_currentUser.id)
        .update({"addresses": data});
  }

  Future<UserAddressesModel?> getAddressData({required String userId}) async {
    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.userAddressCollection.doc(userId).get();

    if (!documentSnapshot.exists) {
      await FirestoreCollection.userAddressCollection.doc(userId).set({
        "addresses": {},
        "default": "",
        "uid": userId,
      });
      return UserAddressesModel(
        addresses: [],
        defaultAddress: "",
        uid: userId,
      );
    }

    if (documentSnapshot.data().toString().length > 2) {
      return UserAddressesModel.fromJson(documentSnapshot.data());
    } else {
      return UserAddressesModel(
        addresses: [],
        defaultAddress: "",
        uid: userId,
      );
    }
  }

  Future<void> setDeafultAddressId(
      BuildContext context, String? addressId) async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await FirestoreCollection.userAddressCollection
        .doc(_userProvider.getCurrentUser!.id)
        .update({"default": addressId ?? ""});
  }
}
