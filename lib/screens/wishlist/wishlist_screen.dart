import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/empty_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';

import 'components/wishlist_product_tile.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishlistProvider _provider;
  late CartProvider _cartProvider;
  @override
  void initState() {
    _provider = Provider.of(context, listen: false);
    _cartProvider = Provider.of(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_provider.isDataLoaded == false) {
        _provider.fetchWishlistData(userId: widget.userId);
      }
      if (_cartProvider.isDataLoaded == false) {
        _cartProvider.fetchCartData(userId: widget.userId);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Wishlist",
      body: Consumer<UserProvider>(
        builder: (context, userprovider, _) => Consumer<CartProvider>(
          builder: (context, cartprovider, _) => Consumer<WishlistProvider>(
              builder: (context, wishlistprovider, _) {
            if (wishlistprovider.allWishlistProducts.isNotEmpty &&
                wishlistprovider.isDataLoaded == true &&
                cartprovider.isDataLoaded == true) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight! * .015),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    ProductListModel data =
                        wishlistprovider.allWishlistProducts[index];
                    bool isProductInCart = cartprovider.allCartData!.products!
                        .where((element) => element.id == data.id)
                        .isNotEmpty;
                    return WishlistProductTile(
                        index: index,
                        data: data,
                        isProductInCart: isProductInCart);
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                  itemCount: wishlistprovider.allWishlistProducts.length,
                ),
              );
            } else if (wishlistprovider.allWishlistProducts.isEmpty &&
                wishlistprovider.isDataLoaded == true &&
                cartprovider.isDataLoaded == true) {
              return const EmptyDataWidget(
                assetImage: "assets/wishlist_blank.png",
                title: "Wishlist is empty",
                subTitle:
                    "Go back and add some items to wishlist and come back here.",
              );
            }
            return Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .03),
              child: CustomLoadingIndicator(
                  indicatorSize: SizeConfig.screenHeight! * .025),
            );
          }),
        ),
      ),
    );
  }
}
