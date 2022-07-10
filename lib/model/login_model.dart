import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';

class LoginResponseModel {
  late bool success;
  late int statusCode;
  late String code;
  late String message;
  UserData? userData;

  LoginResponseModel({
    required this.success,
    required this.statusCode,
    required this.code,
    required this.message,
    this.userData,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    statusCode = json["statusCode"];
    code = json["code"];
    message = json["message"];
    userData = (json["data"] != null ? UserData.fromJson(json["data"]) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["success"] = success;
    data["statusCode"] = statusCode;
    data["code"] = code;
    data["message"] = message;
    data["data"] = userData!.toJson();

    return data;
  }
}
