import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/user_cart.dart';
import 'package:flutter_firebase_ecommerce_app/model/cart.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import '../model/product.dart';

class CartProvider extends ChangeNotifier {
  CartModel? _cartData;
  bool _isDataLoaded = false;
  double? _totalAmountPaid;
  double _discount = 0;
  double _totalCost = 0;

  UserAddressObject? _defaultCartDeliveryAddress;

  Future<void> resetData({required String userId}) async {
    _discount = 0;
    _totalAmountPaid = 0;
    _cartData!.products!.clear();

    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    await UserCartDatabaseConnection().clearCartData(userId: userId);
  }

  CartModel? get allCartData => _cartData;
  bool get isDataLoaded => _isDataLoaded;
  double? get totalAmountPaid => _totalAmountPaid;
  double? get totalCost => _totalCost;
  double? get discount => _discount;

  UserAddressObject? get getCartDeliveryAddress => _defaultCartDeliveryAddress;

  Future<void> fetchCartData({required String userId}) async {
    _cartData =
        await UserCartDatabaseConnection().fetchCartData(userId: userId);

    getTotalCost();

    _isDataLoaded = true;
    notifyListeners();
  }

  addProductLocally(ProductListModel productData) {
    _cartData!.products!.add(productData);

    notifyListeners();
  }

  Future<void> moveCartProductToWishlist(BuildContext context,
      {required String userId, required ProductListModel productData}) async {
    _cartData!.products!
        .removeWhere((element) => element.id == productData.id!);

    WishlistProvider _wishlistProvider = Provider.of(context, listen: false);
    _wishlistProvider.allWishlistProducts.add(productData);

    if (productData.salePrice != 0) {
      _totalAmountPaid = _totalAmountPaid! - productData.salePrice!;
      _discount -= productData.price! - productData.salePrice!;
    } else {
      _totalAmountPaid = _totalAmountPaid! - productData.price!;
    }
    _totalCost = _totalCost - productData.price!;

    await UserCartDatabaseConnection().cartToWishlistAndViceVersa(
        userId: userId,
        wishlistData: _wishlistProvider.allWishlistProducts,
        cartData: _cartData!.products!);

    notifyListeners();
  }

  Future<void> modifyList(
      {required ProductListModel product, required String userId}) async {
    if (_cartData!.products!.contains(product)) {
      _cartData!.products!.remove(product);
      if (product.salePrice != 0) {
        _totalAmountPaid = _totalAmountPaid! - product.salePrice!;
        _discount -= product.price! - product.salePrice!;
      } else {
        _totalAmountPaid = _totalAmountPaid! - product.price!;
      }
      _totalCost = _totalCost - product.price!;
    } else {
      _cartData!.products!.add(product);
      if (product.salePrice != 0) {
        _totalAmountPaid = _totalAmountPaid! + product.salePrice!;
        _discount += product.price! - product.salePrice!;
      } else {
        _totalAmountPaid = _totalAmountPaid! + product.price!;
      }
      _totalCost = _totalCost + product.price!;
    }

    List<Map<String, dynamic>> _productMapData = [];
    for (ProductListModel element in _cartData!.products!) {
      _productMapData.add(element.productToWishlistCartJson());
    }

    await UserCartDatabaseConnection()
        .updateCartData(userId: userId, productsData: _productMapData);

    notifyListeners();
  }

  void getTotalCost() {
    _totalAmountPaid = 0;
    _totalCost = 0;
    _discount = 0;
    for (var element in _cartData!.products!) {
      if (element.salePrice != 0) {
        _totalAmountPaid = _totalAmountPaid! + element.salePrice!;
        _discount += element.price! - element.salePrice!;
      } else {
        _totalAmountPaid = _totalAmountPaid! + element.price!;
      }
      _totalCost = _totalCost + element.price!;
    }
  }

  ///function to set default delivery address
  Future<void> setCartDeliveryAddress(UserAddressObject? addressObject) async {
    _defaultCartDeliveryAddress = addressObject;

    notifyListeners();
  }
}
