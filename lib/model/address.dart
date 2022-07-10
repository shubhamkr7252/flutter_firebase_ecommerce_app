class AddressModel {
  String? type;
  String? address_1;
  String? address_2;
  String? city;
  String? state;
  int? pinCode;
  String? country;

  AddressModel({
    this.type,
    this.address_1,
    this.address_2,
    this.city,
    this.state,
    this.pinCode,
    this.country,
  });

  factory AddressModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return AddressModel(
      type: data["type"],
      address_1: data["address_1"],
      address_2: data["address_2"],
      city: data["city"],
      state: data["state"],
      pinCode: data["pinCode"],
      country: data["country"],
    );
  }
}
