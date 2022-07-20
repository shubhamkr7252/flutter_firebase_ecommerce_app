import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/firebase_auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/user.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/auth_service.dart';
import 'package:flutter_firebase_ecommerce_app/extension/string_casing_extension.dart';

import '../screens/home main navigation/home_main_navigation.dart';
import '../service/hive_boxes.dart';
import '../service/navigator_service.dart';

class UserProvider extends ChangeNotifier {
  UserData? _currentUser;
  bool _isLoading = false;

  UserData? get getCurrentUser => _currentUser;
  bool get isLoading => _isLoading;

  void resetData() {
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> init(
      {required String userId,
      required String token,
      UserData? userData}) async {
    if (userData == null) {
      _currentUser = await UserDatabaseConnection()
          .fetchUserData(userId: userId, token: token);
    } else {
      _currentUser = userData;
    }

    notifyListeners();

    if (_currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  ///function for phone authentication
  Future<void> phoneLogin(BuildContext context,
      {required Map<String, dynamic>? userIdAndToken}) async {
    if (userIdAndToken != null) {
      UserData _newUserData = UserData.fromJson({
        "id": userIdAndToken["uid"],
        "firstName": "",
        "lastName": "",
        "email": "",
        "image": null,
        "phoneNumber": userIdAndToken["phone"],
        "tokens": [userIdAndToken["token"]],
        "isEmailVerified": false,
      });

      UserData? _userDocData = await UserDatabaseConnection().fetchUserData(
          userId: userIdAndToken["uid"], token: userIdAndToken["token"]);

      if (_userDocData == null) {
        await UserDatabaseConnection().addNewUserData(data: _newUserData);
        _currentUser = _newUserData;
      } else {
        _currentUser = _userDocData;
      }

      HiveBoxes.registerAdapters();

      notifyListeners();

      NavigatorService.push(context, page: const HomeMainNavigation());
    } else {
      return;
    }
  }

  ///function to update user data
  Future<void> updateUserData(BuildContext context,
      {required String firstName,
      required String? lastName,
      required String email}) async {
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
    if (email != _currentUser!.email) {
      _currentUser!.email = email.toLowerCase();
      _isDataChanged = true;
    }

    UploadUserProfileImageProvider _provider =
        Provider.of(context, listen: false);
    if (_provider.getImageFile != null) {
      await _provider.uploadImage(context, currentUser: _currentUser!.id!);
    }

    if (_isDataChanged) {
      await UserDatabaseConnection().updateUserData(userData: _currentUser!);
    }

    _isLoading = false;
    notifyListeners();
  }

  ///function for logout
  Future<void> userLogout(BuildContext context) async {
    OSDeviceState? _oneSignalStatus = await OneSignal.shared.getDeviceState();
    await UserDatabaseConnection().removeTokenData(
        userId: _currentUser!.id!, token: _oneSignalStatus!.userId!);

    SearchProvider _seachProvider = Provider.of(context, listen: false);
    _seachProvider.resetData();

    CartProvider _cartProvider = Provider.of(context, listen: false);
    _cartProvider.resetData();

    OrderProvider _orderProvider = Provider.of(context, listen: false);
    _orderProvider.resetData();

    WishlistProvider _wishlistProvider = Provider.of(context, listen: false);
    _wishlistProvider.resetData();

    NotificationProvider _notifciationProvider =
        Provider.of(context, listen: false);
    _notifciationProvider.resetData();

    UserAddressesProvider _userAddressProvider =
        Provider.of(context, listen: false);
    _userAddressProvider.resetData();

    await HiveBoxes.clearData();

    await AuthService.logout(context);
    notifyListeners();
  }

  ///function to delete account and reset all provider data
  Future<void> deleteAccount(BuildContext context) async {
    await UserDatabaseConnection()
        .deleteUserAccount(context, userId: _currentUser!.id!);

    SearchProvider _seachProvider = Provider.of(context, listen: false);
    _seachProvider.resetData();

    CartProvider _cartProvider = Provider.of(context, listen: false);
    _cartProvider.resetData();

    OrderProvider _orderProvider = Provider.of(context, listen: false);
    _orderProvider.resetData();

    WishlistProvider _wishlistProvider = Provider.of(context, listen: false);
    _wishlistProvider.resetData();

    NotificationProvider _notifciationProvider =
        Provider.of(context, listen: false);
    _notifciationProvider.resetData();

    UserAddressesProvider _userAddressProvider =
        Provider.of(context, listen: false);
    _userAddressProvider.resetData();

    await HiveBoxes.clearData();

    await FirebaseAuthService.deleteAccount(context);
  }
}
