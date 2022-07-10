class CateogoryModel {
  List<CategoryObject>? categories;
  List<String>? top;

  CateogoryModel({
    this.categories,
    this.top,
  });

  factory CateogoryModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<CategoryObject> getAllCategories(List obj) {
      List<CategoryObject> _list = [];
      for (var element in obj) {
        _list.add(CategoryObject.fromJson(element));
      }

      return _list;
    }

    return CateogoryModel(
      top: List.from(data["top"]),
      categories: getAllCategories(data["categories"]),
    );
  }
}

class CategoryObject {
  late String categoryId;

  late String categoryName;

  late String parentId;

  late String image;

  late List<String> top;

  CategoryObject({
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.parentId,
    required this.top,
  });

  factory CategoryObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return CategoryObject(
      categoryId: data["id"] ?? "",
      categoryName: data["name"] ?? "",
      image: data["image"] ?? "",
      parentId: data["parent_id"] ?? "",
      top: data["top"] ?? [],
    );
  }
}
