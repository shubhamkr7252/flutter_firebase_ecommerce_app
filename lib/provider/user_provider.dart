import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/user.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20main%20navigation/home_main_navigation.dart';
import 'package:flutter_firebase_ecommerce_app/service/auth_service.dart';
import 'package:flutter_firebase_ecommerce_app/service/firebase_auth_service.dart';
import 'package:flutter_firebase_ecommerce_app/service/hive_boxes.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/extension/string_casing_extension.dart';

class UserProvider extends ChangeNotifier {
  UserData? _currentUser;
  bool _isLoading = false;

  UserData? get getCurrentUser => _currentUser;
  bool get isLoading => _isLoading;

  void resetData() {
    _currentUser = null;
  }

  Future<void> init({required String userId}) async {
    _currentUser = await UserDatabaseConnection().fetchUserData(userId: userId);
    notifyListeners();
  }

  void updateUserImageToProvider(String imageSrc) {
    _currentUser!.image = imageSrc;
  }

  Future<void> userLogout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await AuthService.logout(context);
  }

  Future<void> addCustomer(BuildContext context,
      {required UserData userData, required String password}) async {
    String userId = await FirebaseAuthService.createUser(
        email: userData.email!, password: password);

    UserData newUserData = UserData.fromJson({
      "id": userId,
      "firstName": userData.firstName,
      "lastName": userData.lastName,
      "email": userData.email,
    });

    await UserDatabaseConnection().addNewCustomerData(data: newUserData);
    _currentUser = newUserData;

    HiveBoxes.registerAdapters();

    NavigatorService.pushReplaceUntil(context,
        page: const HomeMainNavigation());
  }

  Future<void> login(BuildContext context,
      {required String email, required String password}) async {
    String userId =
        await FirebaseAuthService.login(email: email, password: password);
    _currentUser = await UserDatabaseConnection().fetchUserData(userId: userId);

    HiveBoxes.registerAdapters();

    NavigatorService.pushReplaceUntil(context,
        page: const HomeMainNavigation());
  }

  Future<void> updateUserNameDataAndImage(BuildContext context,
      {required String firstName, required String? lastName}) async {
    _isLoading = true;
    notifyListeners();

    bool _isDataChanged = false;

    if (firstName.isNotEmpty && firstName != _currentUser!.firstName) {
      _currentUser!.firstName = firstName..toCapitalized();
      _isDataChanged = true;
    }
    if (lastName != null &&
        lastName.isNotEmpty &&
        lastName != _currentUser!.lastName) {
      _currentUser!.lastName = lastName.toCapitalized();
      _isDataChanged = true;
    }

    UploadUserProfileImageProvider _provider =
        Provider.of(context, listen: false);
    if (_provider.getImageFile != null) {
      await _provider.uploadImage(context, currentUser: _currentUser!.id!);
    }

    if (_isDataChanged) {
      await UserDatabaseConnection()
          .updateCustomerNameData(userData: _currentUser!);
    }

    _isLoading = false;
    notifyListeners();
  }
}
