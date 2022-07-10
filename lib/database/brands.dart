import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/brand.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class BrandsDatabaseConnection {
  Future<BrandModel?> fetchBrandsData() async {
    DocumentSnapshot documentSnapshot = await FirestoreCollection
        .categoriesCollection
        .doc("000ALLBRANDS")
        .get();

    if (documentSnapshot.exists) {
      return BrandModel.fromJson(documentSnapshot.data());
    }

    return null;
  }
}
