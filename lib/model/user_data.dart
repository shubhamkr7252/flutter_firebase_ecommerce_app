class UserData {
  String? email;

  String? firstName;

  String? lastName;

  String? id;

  String? image;

  UserData(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.image});

  factory UserData.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserData(
        id: data["id"] ?? "",
        email: data["email"] ?? "",
        firstName: data["firstName"] ?? "",
        lastName: data["lastName"] ?? "",
        image: data["image"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["email"] = email;
    data["image"] = image;
    data["firstName"] = firstName;
    data["lastName"] = lastName;

    return data;
  }
}
