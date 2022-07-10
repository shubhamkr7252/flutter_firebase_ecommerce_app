import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/search_query.dart';
import 'package:flutter_firebase_ecommerce_app/service/hive_boxes.dart';

class SearchProvider extends ChangeNotifier {
  List<SearchQueryModel> _allSearchQueryData = [];
  List<ProductListModel> _allPreviousVisitedProducts = [];
  bool _isDataLoaded = false;

  List<SearchQueryModel> get finalSearchQueryData => _allSearchQueryData;
  List<ProductListModel> get allPreviousVisitedProducts =>
      _allPreviousVisitedProducts;
  bool get isDataLoaded => _isDataLoaded;

  Future<void> modifySearchQueryList(SearchQueryModel query) async {
    if (_allSearchQueryData
        .where((element) => element.queryText == query.queryText!.toLowerCase())
        .isNotEmpty) {
      return;
    } else if (_allSearchQueryData.length == 20) {
      _allSearchQueryData.removeLast();
      _allSearchQueryData.add(query);
    } else {
      _allSearchQueryData.add(query);
    }

    await Hive.openBox<SearchQueryModel>("previousSearchTextListBox");
    await HiveBoxes.previousSearchTextListBox().clear();
    await HiveBoxes.previousSearchTextListBox().addAll(_allSearchQueryData);

    await HiveBoxes.previousSearchTextListBox().close();

    notifyListeners();
  }

  Future<void> removeSeachQueryData(SearchQueryModel data) async {
    _allSearchQueryData.remove(data);

    await Hive.openBox<SearchQueryModel>("previousSearchTextListBox");
    await HiveBoxes.previousSearchTextListBox().clear();
    await HiveBoxes.previousSearchTextListBox().addAll(_allSearchQueryData);

    await HiveBoxes.previousSearchTextListBox().close();
    notifyListeners();
  }

  Future<void> addPreviousProductData(
      {required ProductListModel productData}) async {
    if (_allPreviousVisitedProducts
        .where((element) => element.id == productData.id)
        .isEmpty) {
      if (_allPreviousVisitedProducts.length < 4) {
        _allPreviousVisitedProducts.add(productData);
      } else {
        _allPreviousVisitedProducts.removeAt(0);
        _allPreviousVisitedProducts.add(productData);
      }
    }

    await Hive.openBox<ProductListModel>("previousVisitedProductList");
    await HiveBoxes.previousVisitedProductListBox().clear();
    await HiveBoxes.previousVisitedProductListBox()
        .addAll(_allPreviousVisitedProducts);

    await HiveBoxes.previousVisitedProductListBox().close();

    notifyListeners();
  }

  Future<void> removePreviousProductData(
      {required ProductListModel data}) async {
    _allPreviousVisitedProducts.removeWhere((element) => element.id == data.id);

    await Hive.openBox<ProductListModel>("previousVisitedProductList");
    await HiveBoxes.previousVisitedProductListBox().clear();
    await HiveBoxes.previousVisitedProductListBox()
        .addAll(_allPreviousVisitedProducts);

    await HiveBoxes.previousVisitedProductListBox().close();

    notifyListeners();
  }

  Future<void> fetchSearchQueryData() async {
    await Hive.openBox<ProductListModel>("previousVisitedProductList");
    _allPreviousVisitedProducts =
        HiveBoxes.previousVisitedProductListBox().values.toList();

    await Hive.openBox<SearchQueryModel>("previousSearchTextListBox");
    _allSearchQueryData = HiveBoxes.previousSearchTextListBox().values.toList();

    await Hive.close();

    _isDataLoaded = true;
    notifyListeners();
  }
}
