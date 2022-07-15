import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/database/home_cms_banner.dart';
import 'package:flutter_firebase_ecommerce_app/database/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_banner.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';

class HomeCMSProvider extends ChangeNotifier {
  final List<HomeCMSHighlightsModel> _allHomeCMSHighlightsData = [];
  List<HomeCMSHighlightsBlueprintModel> _allHomeCMSHighlightsBlueprintData = [];
  HomeCMSBannerModel? _homeCMSBannerData;

  bool _isHighlightsDataLoaded = false;
  bool _isBannerDataLoaded = false;

  List<HomeCMSHighlightsModel> get allHomeCMSHighlightsData =>
      _allHomeCMSHighlightsData;
  List<HomeCMSHighlightsBlueprintModel> get allHomeCMSHighlightsBlueprintData =>
      _allHomeCMSHighlightsBlueprintData;
  HomeCMSBannerModel? get allHomeCMSBannerData => _homeCMSBannerData;
  bool get isHighlightsDataLoaded => _isHighlightsDataLoaded;
  bool get isBannerDataLoaded => _isBannerDataLoaded;

  Future<void> fetchCMSHomeBannerData() async {
    _homeCMSBannerData =
        await HomeCMSBannerDatabaseConnection.getHomeCMSBannerData();

    _isBannerDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchCMSHomeHighlightsBlueprintData() async {
    _allHomeCMSHighlightsBlueprintData =
        await HomeCMSHighlightsDatabaseConnection().getHomeHighlightsData();

    for (int i = 0; i < 1; i++) {
      await fetchCMSHomeHighlightsData(
          data: _allHomeCMSHighlightsBlueprintData[i]);
    }
    _isHighlightsDataLoaded = true;
    notifyListeners();
  }

  Future<void> fetchCMSHomeHighlightsData(
      {required HomeCMSHighlightsBlueprintModel data}) async {
    HomeCMSHighlightsModel _highlightsData =
        await HomeCMSHighlightsDatabaseConnection()
            .getHightlightsAllData(data: data);

    _allHomeCMSHighlightsData.add(_highlightsData);
    notifyListeners();
  }
}
