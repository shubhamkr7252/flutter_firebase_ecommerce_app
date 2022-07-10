import 'package:flutter_firebase_ecommerce_app/model/product.dart';

class WishlistModel {
  List<ProductListModel>? products;
  String? id;

  WishlistModel({
    this.products,
    this.id,
  });

  factory WishlistModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<ProductListModel> getAllProducts(List obj) {
      List<ProductListModel> _list = [];
      for (var element in obj) {
        _list.add(ProductListModel.fromJson(element));
      }

      return _list;
    }

    return WishlistModel(
      id: data["_id"],
      products: getAllProducts(data["products"]),
    );
  }
}
