import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/database/home_cms_banner.dart';
import 'package:flutter_firebase_ecommerce_app/database/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_banner.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';

class HomeCMSProvider extends ChangeNotifier {
  List<HomeCMSHighlightsModel>? _allHomeCMSHighlightsData;
  HomeCMSBannerModel? _homeCMSBannerData;

  bool _isHighlightsDataLoaded = false;
  bool _isBannerDataLoaded = false;

  List<HomeCMSHighlightsModel>? get allHomeCMSHighlightsData =>
      _allHomeCMSHighlightsData;
  HomeCMSBannerModel? get allHomeCMSBannerData => _homeCMSBannerData;
  bool get isHighlightsDataLoaded => _isHighlightsDataLoaded;
  bool get isBannerDataLoaded => _isBannerDataLoaded;

  Future<void> fetchCMSHomeBannerData() async {
    _homeCMSBannerData =
        await HomeCMSBannerDatabaseConnection.getHomeCMSBannerData();

    _isBannerDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchCMSHomeHighlightsData() async {
    _allHomeCMSHighlightsData =
        await HomeCMSHighlightsDatabaseConnection().getHomeHighlightsData();

    _isHighlightsDataLoaded = true;
    notifyListeners();
  }
}
