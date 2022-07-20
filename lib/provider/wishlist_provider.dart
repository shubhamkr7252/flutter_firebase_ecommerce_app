import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/database/user_cart.dart';
import 'package:flutter_firebase_ecommerce_app/database/user_wishlist.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';

class WishlistProvider extends ChangeNotifier {
  List<ProductListModel> _allWishlistProducts = [];
  bool _isDataLoaded = false;

  List<ProductListModel> get allWishlistProducts => _allWishlistProducts;
  bool get isDataLoaded => _isDataLoaded;

  void resetData() {
    _allWishlistProducts.clear();
    _isDataLoaded = false;

    notifyListeners();
  }

  Future<void> fetchWishlistData({required String userId}) async {
    await UserWishlistDatabaseConnection.getUserWishlistData(userId: userId)
        .then((wishlistData) async {
      if (wishlistData != null) {
        _allWishlistProducts = wishlistData.products!;
      }

      _isDataLoaded = true;
      notifyListeners();
    });
  }

  Future<void> modifyList(ProductListModel data,
      {required String userId}) async {
    if (_allWishlistProducts
        .where((element) => element.id == data.id)
        .isNotEmpty) {
      _allWishlistProducts.removeWhere((element) => element.id == data.id);
    } else {
      _allWishlistProducts.add(data);
    }

    await UserWishlistDatabaseConnection.updateUserWishlistData(
        userId: userId, products: _allWishlistProducts);

    notifyListeners();
  }

  Future<void> moveWishlistProductToCart(BuildContext context,
      {required String userId, required ProductListModel productData}) async {
    _allWishlistProducts
        .removeWhere((element) => element.id == productData.id!);

    CartProvider _cartProvider = Provider.of(context, listen: false);
    _cartProvider.addProductLocally(productData);

    await UserCartDatabaseConnection().cartToWishlistAndViceVersa(
        userId: userId,
        wishlistData: _allWishlistProducts,
        cartData: _cartProvider.allCartData!.products!);

    notifyListeners();
  }

  Future<void> removeItem(ProductListModel data,
      {required String userId}) async {
    _allWishlistProducts.removeWhere((element) => element.id == data.id);

    await UserWishlistDatabaseConnection.updateUserWishlistData(
        userId: userId, products: _allWishlistProducts);

    notifyListeners();
  }
}
