import 'package:flutter_firebase_ecommerce_app/database/category.dart';
import 'package:flutter_firebase_ecommerce_app/model/category.dart';
import 'package:flutter/foundation.dart';

class CategoriesProvider extends ChangeNotifier {
  CateogoryModel? _allCategoryModelData;
  bool _isDataLoaded = false;

  CateogoryModel? get allCategoryModelData => _allCategoryModelData;
  bool get isDataLoaded => _isDataLoaded;

  Future<void> fetchCategoryModelData() async {
    _allCategoryModelData =
        await CategoryDatabaseConnection().fetchCategoryData();

    _isDataLoaded = true;
    notifyListeners();
  }
}
