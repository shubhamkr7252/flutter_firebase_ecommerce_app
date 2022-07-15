import 'package:hive/hive.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/search_query.dart';

class HiveBoxes {
  static Box<ProductListModel> previousVisitedProductListBox() =>
      Hive.box<ProductListModel>("previousVisitedProductList");
  static Box<SearchQueryModel> previousSearchTextListBox() =>
      Hive.box<SearchQueryModel>("previousSearchTextListBox");

  static void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<ProductListModel>(ProductListModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<SearchQueryModel>(SearchQueryModelAdapter());
    }
  }
}
