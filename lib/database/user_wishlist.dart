import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/wishlist.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class UserWishlistDatabaseConnection {
  static Future<WishlistModel?> getUserWishlistData(
      {required String userId}) async {
    DocumentSnapshot _doc =
        await FirestoreCollection.userWishlistCollection.doc(userId).get();

    if (_doc.exists) {
      return WishlistModel.fromJson(_doc.data());
    } else {
      return WishlistModel.fromJson({"products": [], "userId": {}});
    }
  }

  static Future<void> updateUserWishlistData(
      {required String userId,
      required List<ProductListModel> products}) async {
    List<Map<String, dynamic>> productsMapData = [];
    for (ProductListModel element in products) {
      productsMapData.add(element.productToWishlistCartJson());
    }

    await FirebaseFirestore.instance
        .collection("UserWishlist")
        .doc(userId)
        .set({
      "products": productsMapData,
      "userId": userId,
    });
  }
}
