import 'package:hive/hive.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/search_query.dart';

class HiveBoxes {
  static Box<ProductListModel> previousVisitedProductListBox() =>
      Hive.box<ProductListModel>("previousVisitedProductList");
  static Box<SearchQueryModel> previousSearchTextListBox() =>
      Hive.box<SearchQueryModel>("previousSearchTextListBox");

  static registerAdapters() {
    Hive.registerAdapter<ProductListModel>(ProductListModelAdapter());
    Hive.registerAdapter<SearchQueryModel>(SearchQueryModelAdapter());
  }
}
