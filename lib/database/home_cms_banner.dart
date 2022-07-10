import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_banner.dart';
import 'package:flutter_firebase_ecommerce_app/service/firestore_collections.dart';

class HomeCMSBannerDatabaseConnection {
  static Future<HomeCMSBannerModel?> getHomeCMSBannerData() async {
    DocumentSnapshot _doc =
        await FirestoreCollection.cmsCollection.doc("Home").get();

    if (_doc.exists) {
      return HomeCMSBannerModel.fromJson(_doc.data());
    } else {
      return HomeCMSBannerModel.fromJson({
        "banners": [],
      });
    }
  }
}
