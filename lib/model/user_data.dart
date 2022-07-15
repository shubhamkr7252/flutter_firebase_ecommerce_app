class UserData {
  String? email;

  String? firstName;

  String? lastName;

  String? id;

  String? image;

  List<String>? tokens;

  UserData({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    this.tokens,
  });

  factory UserData.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserData(
      id: data["id"] ?? "",
      email: data["email"] ?? "",
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      image: data["image"] == null || data["image"].toString().isEmpty
          ? "https://www.wallpaperup.com/template/dist/images/default/avatar.png?v=3.5.1"
          : data["image"],
      tokens: List.from(data["tokens"]),
    );
  }

  toJson() => {
        "id": id,
        "email": email,
        "image": image,
        "firstName": firstName,
        "lastName": lastName,
        "tokens": tokens,
      };
}
