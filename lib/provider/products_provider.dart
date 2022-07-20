import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/database/products.dart';
import 'package:flutter_firebase_ecommerce_app/database/seach.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';


class ProductProvider with ChangeNotifier {
  List<ProductListModel> _allProductsData = [];
  bool _isDataLoaded = false;
  ProductModel? _productData;

  bool get isDataLoaded => _isDataLoaded;
  List<ProductListModel> get allProductsData => _allProductsData;
  ProductModel? get productData => _productData;

  resetData() {
    _allProductsData.clear();
    _isDataLoaded = false;
  }

  setDataLoading() {
    _isDataLoaded = false;
  }

  Future<void> fetchCategoryProductsData({required String categoryId}) async {
    _allProductsData = await ProductsDatabaseConnection()
        .fetchCategoryProductsData(categoryId: categoryId);

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchBrandProductsData({required String brandId}) async {
    _allProductsData = await ProductsDatabaseConnection()
        .fetchBrandProductsData(brandId: brandId);

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchSearchQueryResultProductData(
      {required String query}) async {
    _allProductsData = await SearchDatabaseConnection()
        .getProductSearchQueryData(query: query);

    _isDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchProductData({required String productId}) async {
    _productData =
        await ProductsDatabaseConnection().getProductData(productId: productId);

    _isDataLoaded = true;
    notifyListeners();
  }
}
