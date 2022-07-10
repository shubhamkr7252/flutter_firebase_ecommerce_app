class UserAddressesModel {
  String? uid, defaultAddress;
  List<UserAddressObject>? addresses;

  UserAddressesModel({
    this.uid,
    this.defaultAddress,
    this.addresses,
  });

  factory UserAddressesModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserAddressesModel(
      uid: data["uid"],
      defaultAddress: data["default"],
      addresses: UserAddressObject.getListObj(data["addresses"]),
    );
  }
}

class UserAddressObject {
  String? addressId,
      title,
      name,
      phone,
      email,
      addressLine1,
      addressLine2,
      city,
      state,
      pinCode;

  UserAddressObject({
    this.addressId,
    this.title,
    this.name,
    this.phone,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pinCode,
  });

  factory UserAddressObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserAddressObject(
      addressId: data["addressId"] ?? "",
      title: data["title"] ?? "",
      name: data["name"] ?? "",
      phone: data["phone"] ?? "",
      email: data["email"] ?? "",
      addressLine1: data["addressLine1"] ?? "",
      addressLine2: data["addressLine2"] ?? "",
      city: data["city"] ?? "",
      state: data["state"] ?? "",
      pinCode: data["pinCode"] ?? "",
    );
  }

  static List<UserAddressObject> getListObj(Map obj) {
    List<UserAddressObject> _temp = [];
    obj.forEach((key, value) {
      _temp.add(UserAddressObject.fromJson({"addressId": key, ...value}));
    });
    return _temp;
  }

  Map<String, dynamic> toJson() => {
        "addressId": addressId ?? "",
        "title": title ?? "",
        "name": name ?? "",
        "phone": phone ?? "",
        "email": email ?? "",
        "addressLine1": addressLine1 ?? "",
        "addressLine2": addressLine2 ?? "",
        "city": city ?? "",
        "state": state ?? "",
        "pinCode": pinCode ?? "",
      };
}
