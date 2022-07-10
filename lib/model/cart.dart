import 'package:flutter_firebase_ecommerce_app/model/product.dart';

class CartModel {
  List<ProductListModel>? products;
  String? userId;

  CartModel({
    this.products,
    this.userId,
  });

  factory CartModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<ProductListModel> getAllProducts(List obj) {
      List<ProductListModel> _list = [];
      for (var element in obj) {
        _list.add(ProductListModel.fromJson(element));
      }
      return _list;
    }

    return CartModel(
      products: getAllProducts(data["products"] ?? []),
      userId: data["userId"] ?? "",
    );
  }
}
