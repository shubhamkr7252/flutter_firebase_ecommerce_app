import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';
import '../service/firestore_collections.dart';

class HomeCMSHighlightsDatabaseConnection {
  Future<List<HomeCMSHighlightsBlueprintModel>> getHomeHighlightsData() async {
    DocumentSnapshot _doc =
        await FirestoreCollection.cmsCollection.doc("Home").get();

    List<HomeCMSHighlightsBlueprintModel> docJson = [];

    for (var element in _doc.get("highlights")) {
      docJson.add(HomeCMSHighlightsBlueprintModel.fromJson(element));
    }

    return docJson;
  }

  Future<HomeCMSHighlightsModel> getHightlightsAllData(
      {required HomeCMSHighlightsBlueprintModel data}) async {
    List<dynamic> _docSnaps = [];
    for (var element in data.products!) {
      var data =
          await FirestoreCollection.productsCollection.doc(element).get();
      _docSnaps.add(data.data());
    }

    HomeCMSHighlightsModel _highlightsData = HomeCMSHighlightsModel.fromJson({
      "products": _docSnaps,
      "name": data.name!,
      "id": data.id!,
    });

    return _highlightsData;
  }
}
