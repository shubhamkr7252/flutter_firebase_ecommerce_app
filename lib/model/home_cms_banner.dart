class HomeCMSBannerModel {
  List<HomeCMSBannerObject>? banners;

  HomeCMSBannerModel({
    this.banners,
  });

  factory HomeCMSBannerModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<HomeCMSBannerObject> getAllBannerData(List obj) {
      List<HomeCMSBannerObject> _list = [];
      for (var element in obj) {
        _list.add(HomeCMSBannerObject.fromJson(element));
      }

      return _list;
    }

    return HomeCMSBannerModel(
      banners: getAllBannerData(data["banners"]),
    );
  }
}

class HomeCMSBannerObject {
  String? image, title, type;

  HomeCMSBannerObject({
    this.image,
    this.title,
    this.type,
  });

  factory HomeCMSBannerObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return HomeCMSBannerObject(
      image: data["image"] ?? "",
      title: data["title"] ?? "",
      type: data["type"] ?? "",
    );
  }
}
