import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

  Future<bool> init({required String userId, required String token}) async {
    _currentUser = await UserDatabaseConnection()
        .fetchUserData(userId: userId, token: token);

    notifyListeners();

    if (_currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  ///function for logout
  Future<void> userLogout(BuildContext context) async {
    OSDeviceState? _oneSignalStatus = await OneSignal.shared.getDeviceState();
    await UserDatabaseConnection().removeTokenData(
        userId: _currentUser!.id!, token: _oneSignalStatus!.userId!);
    await AuthService.logout(context);

    notifyListeners();
  }

  ///function to register
  Future<void> addNewUser(BuildContext context,
      {required UserData userData, required String password}) async {
    Map<String, dynamic>? responseUserData =
        await FirebaseAuthService.createUser(context,
            email: userData.email!, password: password);

    if (responseUserData != null) {
      UserData newUserData = UserData.fromJson({
        "id": responseUserData["uid"],
        "firstName": userData.firstName,
        "lastName": userData.lastName,
        "email": userData.email,
        "token": [responseUserData["token"]],
      });

      await UserDatabaseConnection().addNewUserData(data: newUserData);
      _currentUser = newUserData;

      HiveBoxes.registerAdapters();

      NavigatorService.pushReplaceUntil(context,
          page: const HomeMainNavigation());
    } else {
      return;
    }
  }

  ///function to login
  Future<void> login(BuildContext context,
      {required String email, required String password}) async {
    Map<String, dynamic>? responseUserData = await FirebaseAuthService.login(
        context,
        email: email,
        password: password);
    if (responseUserData != null) {
      _currentUser = await UserDatabaseConnection().fetchUserData(
          userId: responseUserData["uid"], token: responseUserData["token"]);

      HiveBoxes.registerAdapters();

      NavigatorService.pushReplaceUntil(context,
          page: const HomeMainNavigation());
    } else {
      return;
    }
  }

  ///function to update user data
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
          .updateUserNameData(userData: _currentUser!);
    }

    _isLoading = false;
    notifyListeners();
  }
}
