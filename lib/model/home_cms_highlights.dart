import 'package:flutter_firebase_ecommerce_app/model/product.dart';

class HomeCMSHighlightsModel {
  String? name, id;
  List<ProductListModel>? products;

  HomeCMSHighlightsModel({
    this.name,
    this.id,
    this.products,
  });

  factory HomeCMSHighlightsModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<ProductListModel> getAllProducts(List obj) {
      List<ProductListModel> _list = [];
      for (var element in obj) {
        _list.add(ProductListModel.fromJson(element));
      }

      return _list;
    }

    return HomeCMSHighlightsModel(
      name: data["name"],
      id: data["id"],
      products: getAllProducts(data["products"]),
    );
  }
}
