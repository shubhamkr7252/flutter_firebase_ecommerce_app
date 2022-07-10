import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class SearchDatabaseConnection {
  Future<List<ProductListModel>> getProductSearchQueryData(
      {required String query}) async {
    List<ProductListModel> _list = [];

    QuerySnapshot querySnapshot = await FirestoreCollection.productsCollection
        .where("tags", arrayContainsAny: [query])
        .orderBy("name")
        .get();

    if (querySnapshot.size != 0) {
      for (var element in querySnapshot.docs) {
        _list.add(ProductListModel.fromJson(element.data()));
      }
    }

    return _list;
  }
}
