import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/category.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class CategoryDatabaseConnection {
  Future<CateogoryModel> fetchCategoryData() async {
    DocumentSnapshot documentSnapshot = await FirestoreCollection
        .categoriesCollection
        .doc("000ALLCATEGORIES")
        .get();

    if (documentSnapshot.exists) {
      return CateogoryModel.fromJson(documentSnapshot.data());
    }
    return CateogoryModel.fromJson({
      "top": [],
      "categories": [],
    });
  }
}
