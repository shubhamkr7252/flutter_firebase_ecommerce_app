import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:collection/collection.dart';
import '../model/user_address.dart';

class UserAddressesProvider extends ChangeNotifier {
  UserAddressesModel? _addressesData;
  UserAddressObject? _defaultAddressData;
  bool _isDataLoaded = false;
  bool _isDataUpdating = false;

  UserAddressesModel? get allAddressesData => _addressesData;
  bool get isDataLoaded => _isDataLoaded;
  bool get isDataUpdating => _isDataUpdating;

  UserAddressObject? get getDefaultAddressData => _defaultAddressData;

  void resetData() {
    _addressesData = null;
    _defaultAddressData = null;
    _isDataLoaded = false;
    _isDataUpdating = false;

    notifyListeners();
  }

  ///function to fetch address data
  Future<void> fetchAddressesData(BuildContext context,
      {required String userId}) async {
    CartProvider _cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    ///initialzing userprovider to get current user
    ///to pass it to getaddressfunction to get data from database
    _addressesData =
        await AddressDatabaseOperations().getAddressData(userId: userId);

    ///setting default address if the addresses list data is not empty
    if (_addressesData!.addresses!.isNotEmpty) {
      _defaultAddressData = _addressesData!.addresses!
          .where(
              (element) => element.addressId == _addressesData!.defaultAddress)
          .first;

      _cartProvider.setCartDeliveryAddress(_defaultAddressData);
    }

    _isDataLoaded = true;
    notifyListeners();
  }

  ///function to rempve address data to cloud and provider
  Future<void> removeAddressData(BuildContext context,
      {required UserAddressObject addressData,
      required UserData currentUser}) async {
    _addressesData!.addresses!.remove(addressData);

    if (_addressesData!.addresses!.isEmpty) {
      _defaultAddressData = null;

      modfiyDeafultAddressData(context: context, addressID: null);
    }

    await _updateAddressDataToCloud(currentUser: currentUser);

    _isDataUpdating = false;
    notifyListeners();
  }

  ///function to update address data to cloud and provider
  Future<void> updateAddressData(BuildContext context,
      {required Map<String, dynamic> oldAddressData,
      required Map<String, dynamic> newAddressData,
      required UserData currentUser}) async {
    _isDataUpdating = true;
    notifyListeners();

    if (const DeepCollectionEquality().equals(oldAddressData, newAddressData) ==
        false) {
      _addressesData!.addresses!.removeWhere(
          (element) => element.addressId == newAddressData["addressId"]);
      _addressesData!.addresses!
          .add(UserAddressObject.fromJson(newAddressData));

      await _updateAddressDataToCloud(currentUser: currentUser);
    }

    _isDataUpdating = false;
    notifyListeners();
  }

  ///function to add address data to cloud and provider
  Future<void> addAddressData(BuildContext context,
      {required Map<String, dynamic> data,
      required int index,
      required UserData currentUser}) async {
    _isDataUpdating = true;
    notifyListeners();

    _addressesData!.addresses!.add(UserAddressObject.fromJson(data));

    await _updateAddressDataToCloud(currentUser: currentUser);

    if (_addressesData!.addresses!.length == 1) {
      modfiyDeafultAddressData(context: context, addressID: data["addressId"]);
    }

    _isDataUpdating = false;
    notifyListeners();
  }

  ///function to update data to cloud
  Future<void> _updateAddressDataToCloud(
      {required UserData currentUser}) async {
    Map<String, Map<String, dynamic>> updatedAddressData = {};

    for (int i = 0; i < _addressesData!.addresses!.length; i++) {
      updatedAddressData[_addressesData!.addresses![i].addressId!] =
          _addressesData!.addresses![i].toJson();
    }

    await AddressDatabaseOperations()
        .addNewAddress(updatedAddressData, currentUser);
  }

  Future<void> modfiyDeafultAddressData(
      {required BuildContext context, required String? addressID}) async {
    ///using cart provider to set a default cart delivery address for the current session
    ///if the app is restarted the data is cleared.
    CartProvider _cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    if (addressID != null) {
      for (var data in _addressesData!.addresses!) {
        if (data.addressId == addressID) {
          _defaultAddressData = data;

          await AddressDatabaseOperations()
              .setDeafultAddressId(context, addressID);

          ///the value of cart delivery address will be updated only if it is null
          ///in other cases, like if we change it ourselves, it won't be again from server
          if (_cartProvider.getCartDeliveryAddress == null) {
            _cartProvider.setCartDeliveryAddress(data);
          }

          break;
        }
      }
    } else {
      _cartProvider.setCartDeliveryAddress(null);
      await AddressDatabaseOperations().setDeafultAddressId(context, addressID);
    }

    notifyListeners();
  }

  ///functio to get index of default address
  ///in the address list
  int? getDefaultAddressIndex({required String addressId}) {
    for (int i = 0; i < _addressesData!.addresses!.length; i++) {
      if (_addressesData!.addresses![i].addressId == addressId) {
        return i;
      }
    }
    return null;
  }
}
