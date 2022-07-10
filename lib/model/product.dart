import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'product.g.dart';

class ProductModel {
  String? id;

  String? name;

  String? brandId;

  List<String>? description;

  double? price;

  double? salePrice;

  int? quantity;

  List<String>? images;

  List<String>? categories;

  List<String>? attributes;

  List<String>? relatedIds;

  List<ProductVariantObject>? variants;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.attributes,
    required this.quantity,
    required this.relatedIds,
    required this.images,
    required this.categories,
    required this.variants,
    required this.brandId,
  });

  factory ProductModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<ProductVariantObject> getVariantsData(List obj) {
      List<ProductVariantObject> _list = [];
      for (var element in obj) {
        _list.add(ProductVariantObject.fromJson(element));
      }

      return _list;
    }

    return ProductModel(
      brandId: data["brandId"] ?? "",
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      description: List.from(data["description"] ?? []),
      price: double.parse(data["price"].toString()),
      salePrice: data["sale_price"] != null
          ? double.parse(data["sale_price"].toString())
          : 0,
      images: List.from(data["images"]),
      variants: (data["variants"] as List).isNotEmpty
          ? getVariantsData(data["variants"])
          : [],
      categories: List.from(data["categories"]),
      relatedIds: List.from(data["cross_sell_ids"] ?? []),
      attributes: List.from(data["attributes"]),
      quantity: data["quantity"],
    );
  }
}

class ProductVariantObject extends HiveObject {
  String? image, color, id;

  ProductVariantObject({
    this.id,
    this.image,
    this.color,
  });

  factory ProductVariantObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return ProductVariantObject(
      id: data["id"] ?? "",
      image: data["image"] ?? "",
      color: data["color"] ?? "",
    );
  }
}

@HiveType(typeId: 0)
class ProductListModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  double? price;

  @HiveField(3)
  double? salePrice;

  @HiveField(4)
  List<String>? images;

  @HiveField(5)
  List<String>? attributes;

  ProductListModel({
    this.id,
    this.name,
    this.price,
    this.salePrice,
    this.images,
    this.attributes,
  });

  factory ProductListModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return ProductListModel(
        id: data["id"] ?? "",
        name: data["name"] ?? "",
        price: double.parse(data["price"].toString()),
        salePrice: data["sale_price"] != null
            ? double.parse(data["sale_price"].toString())
            : 0.0,
        attributes: List.from(data["attributes"]),
        images: List.from(data["images"]));
  }

  Map<String, dynamic> productToWishlistCartJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id ?? "";
    data["name"] = name ?? "";
    data["price"] = price ?? 0.0;
    data["sale_price"] = salePrice ?? 0.0;
    data["attributes"] = attributes ?? [];
    data["images"] = images ?? [];

    return data;
  }

  toJson() => {
        "id": id ?? "",
        "name": name ?? "",
        "price": price ?? 0.0,
        "sale_price": salePrice ?? 0.0,
        "attributes": attributes ?? [],
        "images": images ?? [],
      };

  List<ProductListModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      return ProductListModel(
        id: data["id"] ?? "",
        name: data["name"] ?? "",
        price: double.parse(data["price"].toString()),
        salePrice: data["sale_price"] != null
            ? double.parse(data["sale_price"].toString())
            : 0.0,
        attributes: List.from(data["attributes"]),
        images: List.from(
          data["images"],
        ),
      );
    }).toList();
  }
}
