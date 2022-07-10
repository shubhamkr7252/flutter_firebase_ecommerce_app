import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class ProductsDatabaseConnection {
  Future<List<ProductListModel>> fetchCategoryProductsData(
      {required String categoryId}) async {
    List<ProductListModel> _list = [];
    QuerySnapshot querySnapshot = await FirestoreCollection.productsCollection
        .where("categories", arrayContains: categoryId)
        .orderBy("name")
        .get();

    if (querySnapshot.size != 0) {
      for (var element in querySnapshot.docs) {
        _list.add(ProductListModel.fromJson(element.data()));
      }
    }
    return _list;
  }

  Future<List<ProductListModel>> fetchBrandProductsData(
      {required String brandId}) async {
    List<ProductListModel> _list = [];
    QuerySnapshot querySnapshot = await FirestoreCollection.productsCollection
        .where("brandId", isEqualTo: brandId)
        .orderBy("name")
        .get();

    if (querySnapshot.size != 0) {
      for (var element in querySnapshot.docs) {
        _list.add(ProductListModel.fromJson(element.data()));
      }
    }
    return _list;
  }

  Future<ProductModel?> getProductData({required String productId}) async {
    DocumentSnapshot documentSnapshot =
        await FirestoreCollection.productsCollection.doc(productId).get();

    if (documentSnapshot.exists) {
      return ProductModel.fromJson(documentSnapshot.data());
    } else {
      return null;
    }
  }
}
