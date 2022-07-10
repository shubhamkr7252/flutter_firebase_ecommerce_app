import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/database/brands.dart';
import 'package:flutter_firebase_ecommerce_app/model/brand.dart';

class BrandsProvider extends ChangeNotifier {
  BrandModel? _allBrandsData;
  bool _isDataLoaded = false;

  BrandModel? get allBrandsData => _allBrandsData;
  bool get isDataLoaded => _isDataLoaded;

  Future<void> fetchCategoryModelData() async {
    _allBrandsData = await BrandsDatabaseConnection().fetchBrandsData();

    _isDataLoaded = true;
    notifyListeners();
  }
}
