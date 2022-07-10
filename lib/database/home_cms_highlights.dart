import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';
import '../service/firestore_collections.dart';

class HomeCMSHighlightsDatabaseConnection {
  Future<List<HomeCMSHighlightsModel>> getHomeHighlightsData() async {
    DocumentSnapshot _doc =
        await FirestoreCollection.cmsCollection.doc("Home").get();

    List<HomeCMSHighlightsModel> docJson = [];

    for (var firstElement in _doc.get("highlights")) {
      List<dynamic> _docSnaps = [];
      for (var secondElement in firstElement["products"]) {
        var data = await FirestoreCollection.productsCollection
            .doc(secondElement)
            .get();
        _docSnaps.add(data.data());
      }

      HomeCMSHighlightsModel _highlightsData = HomeCMSHighlightsModel.fromJson({
        "products": _docSnaps,
        "name": firstElement["name"],
        "id": firstElement["id"],
      });

      docJson.add(_highlightsData);
    }

    return docJson;
  }
}
