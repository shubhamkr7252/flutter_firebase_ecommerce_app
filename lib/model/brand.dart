class BrandModel {
  List<BrandObject>? brands;
  List<String>? top;

  BrandModel({
    this.brands,
    this.top,
  });

  factory BrandModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<BrandObject> getAllBrands(List obj) {
      List<BrandObject> _list = [];
      for (var element in obj) {
        _list.add(BrandObject.fromJson(element));
      }

      return _list;
    }

    return BrandModel(
      top: (data["top"] as List).isNotEmpty ? List.from(data["top"]) : [],
      brands: (data["brands"] as List).isNotEmpty
          ? getAllBrands(data["brands"])
          : [],
    );
  }
}

class BrandObject {
  String? image;
  String? brandId;
  String? name;

  BrandObject({
    this.image,
    this.brandId,
    this.name,
  });

  factory BrandObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return BrandObject(
      image: data["image"] ??
          "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
      brandId: data["brandId"] ?? "",
      name: data["name"] ?? "",
    );
  }
}
