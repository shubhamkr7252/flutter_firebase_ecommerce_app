import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/cart.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserCartDatabaseConnection {
  Future<CartModel> fetchCartData({required String userId}) async {
    DocumentSnapshot doc =
        await FirestoreCollection.userCartCollection.doc(userId).get();

    if (doc.exists) {
      return CartModel.fromJson(doc.data());
    } else {
      return CartModel.fromJson({
        "userId": userId,
        "products": [],
      });
    }
  }

  Future<void> clearCartData({required String userId}) async {
    await FirestoreCollection.userCartCollection.doc(userId).set({
      "userId": userId,
      "products": [],
    });
  }

  Future<void> updateCartData(
      {required String userId,
      required List<Map<String, dynamic>> productsData}) async {
    await FirestoreCollection.userCartCollection.doc(userId).set({
      "userId": userId,
      "products": productsData,
    });
  }

  Future<void> cartToWishlistAndViceVersa({
    required String userId,
    required List<ProductListModel> wishlistData,
    required List<ProductListModel> cartData,
  }) async {
    List<Map<String, dynamic>> wishlistDataMapList = [];
    List<Map<String, dynamic>> cartDataMapList = [];

    for (var element in wishlistData) {
      wishlistDataMapList.add(element.toJson());
    }

    for (var element in cartData) {
      cartDataMapList.add(element.toJson());
    }

    var _db = FirebaseFirestore.instance;
    var _batch = _db.batch();

    DocumentReference _wishlistDocRef =
        FirestoreCollection.userWishlistCollection.doc(userId);
    DocumentReference _cartDocRef =
        FirestoreCollection.userCartCollection.doc(userId);

    _batch.update(_wishlistDocRef, {"products": wishlistDataMapList});
    _batch.update(_cartDocRef, {"products": cartDataMapList});

    await _batch.commit();
  }
}
