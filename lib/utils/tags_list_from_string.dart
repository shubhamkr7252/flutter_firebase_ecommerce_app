import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class TagsListFromString {
  static List<String> format(String data) {
    List<String> _tags = [];
    List<String> _productNameData = [];
    _productNameData = data.split(" ");
    for (var element in _productNameData) {
      if (element.contains("-")) {
        _tags.add(element.replaceAll("-", "").toLowerCase());
        _tags.add(element.split("-").last.toLowerCase());
      }
      _tags.add(element.toLowerCase());
    }

    _productNameData.clear();
    _productNameData.addAll(_tags);

    for (var element in _productNameData) {
      for (int i = 1; i < element.length + 1; i++) {
        _tags.add(element.substring(0, i).toLowerCase());
      }
    }

    return _tags;
  }

  Future<void> updateProductTagsDataToFirebase() async {
    QuerySnapshot productsData =
        await FirestoreCollection.productsCollection.get();

    for (var element in productsData.docs) {
      List<String> _tags = TagsListFromString.format(element["name"]);

      await FirestoreCollection.productsCollection.doc(element["id"]).update({
        "tags": _tags,
      });
    }
  }
}
