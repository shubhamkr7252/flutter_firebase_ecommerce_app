import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/place_order_sceen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/empty_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/components/cart_bottom_price_container.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/components/cart_top_address_widget.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/components/money_saved_tile.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'components/cart_product_tile.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key, this.showAppbar = false}) : super(key: key);

  final bool? showAppbar;

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  late UserProvider _userProvider;
  late WishlistProvider _wishlistProvider;
  late UserAddressesProvider _userAddressesProvider;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _userAddressesProvider =
        Provider.of<UserAddressesProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userAddressesProvider.isDataLoaded == false) {
        _userAddressesProvider.fetchAddressesData(context,
            userId: _userProvider.getCurrentUser!.id!);
      }
      if (_wishlistProvider.isDataLoaded == false) {
        _wishlistProvider.fetchWishlistData(
            userId: _userProvider.getCurrentUser!.id!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: "My Cart",
        showAppbar: widget.showAppbar,
        body: Consumer<UserProvider>(builder: (context, userprovider, _) {
          if (userprovider.getCurrentUser != null) {
            return Consumer<WishlistProvider>(
              builder: (context, wishlistprovider, _) =>
                  Consumer<UserAddressesProvider>(
                builder: (context, useraddressprovider, _) =>
                    Consumer<CartProvider>(builder: (context, cartprovider, _) {
                  if (cartprovider.isDataLoaded == true &&
                      cartprovider.allCartData!.products!.isNotEmpty &&
                      wishlistprovider.isDataLoaded == true &&
                      useraddressprovider.isDataLoaded == true) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    height: SizeConfig.screenHeight! * .015),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.screenHeight! * .015),
                                    child: const CartTopAddressWidget()),
                                if (cartprovider.discount != 0)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight! * .015,
                                        right: SizeConfig.screenHeight! * .015,
                                        left: SizeConfig.screenHeight! * .015),
                                    child: MoneySavedTile(
                                        discount: cartprovider.discount!),
                                  ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.screenHeight! * .015),
                                  child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        ProductListModel productData =
                                            cartprovider
                                                .allCartData!.products![index];

                                        bool isProductInWishlist =
                                            wishlistprovider.allWishlistProducts
                                                .where((element) =>
                                                    element.id ==
                                                    productData.id)
                                                .isNotEmpty;
                                        return CartProductTile(
                                            index: index,
                                            productData: productData,
                                            isProductInWishlist:
                                                isProductInWishlist);
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                              height: SizeConfig.screenHeight! *
                                                  .015),
                                      itemCount: cartprovider
                                          .allCartData!.products!.length),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (cartprovider.allCartData!.products!.isNotEmpty)
                          CartBottomPriceContainer(
                            toalAmountPaid: cartprovider.totalAmountPaid!,
                            buttonOnTap: () async {
                              if (cartprovider.getCartDeliveryAddress == null) {
                                return CustomSnackbar.showSnackbar(context,
                                    type: 2,
                                    title:
                                        "Please add an address to continue.");
                              }
                              NavigatorService.push(context,
                                  page: PlaceOrderScreen(
                                    cartData: cartprovider.allCartData!,
                                    discount: cartprovider.discount!,
                                    totalAmount: cartprovider.totalCost!,
                                    defaultAddress:
                                        cartprovider.getCartDeliveryAddress!,
                                    userId: userprovider.getCurrentUser!.id!,
                                    totalAmountPaid:
                                        cartprovider.totalAmountPaid!,
                                  ));
                            },
                            buttonText: 'Place Order',
                          ),
                      ],
                    );
                  } else if (cartprovider.isDataLoaded == true &&
                      cartprovider.allCartData!.products!.isEmpty &&
                      wishlistprovider.isDataLoaded == true &&
                      wishlistprovider.isDataLoaded == true) {
                    return const EmptyDataWidget(
                      assetImage: "assets/empty_cart.png",
                      title: "Cart is Empty",
                      subTitle: "Product(s) added in Cart will appear here.",
                    );
                  }
                  return Center(
                    child: CustomLoader(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }),
              ),
            );
          }
          return Center(
              child: Text(
            "Login to view your Cart",
            style: TextStyle(fontSize: SizeConfig.screenHeight! * .02),
          ));
        }));
  }
}
