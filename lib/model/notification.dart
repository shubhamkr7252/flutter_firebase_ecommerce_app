import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  List<String>? images;
  String? title, description;
  Timestamp? createdAt;

  NotificationModel({
    this.images,
    this.title,
    this.description,
    this.createdAt,
  });

  factory NotificationModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return NotificationModel(
      images: List.from((data["images"] ?? [])),
      title: data["title"] ?? "",
      description: data["description"] ?? "",
      createdAt: data["createdAt"],
    );
  }

  toJson() => {
        "images": images,
        "title": title,
        "createdAt": createdAt,
        "description": description,
      };
}
