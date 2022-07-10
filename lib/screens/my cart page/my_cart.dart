import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/cart_bottom_price_container.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/cart_top_address_widget.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/components/money_saved_tile.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/place%20order/place_order_sceen.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import '../../widgets/custom_elevated_button.dart';
import 'components/cart_product_tile.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key, this.showAppbar = false}) : super(key: key);

  final bool? showAppbar;

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  // late CartProvider _cartProvider;
  late UserProvider _userProvider;
  late WishlistProvider _wishlistProvider;
  late UserAddressesProvider _userAddressesProvider;
  @override
  void initState() {
    // _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _userAddressesProvider =
        Provider.of<UserAddressesProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (_cartProvider.isDataLoaded == false) {
      //   _cartProvider.fetchCartData(userId: _userProvider.getCurrentUser!.id!);
      // }
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
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: SizeConfig.screenHeight! * .015),
                                Consumer<UserAddressesProvider>(
                                    builder: (context, useraddressprovider, _) {
                                  if (useraddressprovider.isDataLoaded ==
                                          true &&
                                      useraddressprovider
                                              .getDefaultAddressData !=
                                          null) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.screenHeight! *
                                                    .015),
                                        child: const CartTopAddressWidget());
                                  }
                                  return const SizedBox();
                                }),
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
                            totalCost: cartprovider.totalCartCost!,
                            buttonOnTap: () async {
                              bool _isOrderPlaced = await Navigator.of(context)
                                  .push(SwipeablePageRoute(
                                      canOnlySwipeFromEdge: true,
                                      builder: (context) => PlaceOrderScreen(
                                            cartData: cartprovider.allCartData!,
                                            discount: cartprovider.discount!,
                                            totalAmount:
                                                cartprovider.totalCartCost!,
                                            defaultAddress: cartprovider
                                                .getCartDeliveryAddress!,
                                            userId: userprovider
                                                .getCurrentUser!.id!,
                                          )));

                              if (_isOrderPlaced == true) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => CartResponseWidget(
                                          title: "Thank you for your order!",
                                          description:
                                              "The order confirmation has been sent to your email address",
                                          lottieSrc:
                                              "assets/lottie_files/order_placed.json",
                                          buttonOnTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          buttonText: "Continue Shopping",
                                        ));
                              }
                            },
                            buttonText: 'Place Order',
                          ),
                      ],
                    );
                  } else if (cartprovider.isDataLoaded == true &&
                      cartprovider.allCartData!.products!.isEmpty &&
                      wishlistprovider.isDataLoaded == true &&
                      wishlistprovider.isDataLoaded == true) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/empty_cart.png",
                              width: SizeConfig.screenWidth! * .4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha(150)),
                          SizedBox(height: SizeConfig.screenWidth! * .02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth! * .1),
                            child: Column(
                              children: [
                                Text(
                                  "Cart is Empty",
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.screenWidth! * .045),
                                ),
                                SizedBox(height: SizeConfig.screenWidth! * .01),
                                Opacity(
                                  opacity: 0.75,
                                  child: Text(
                                    "Product(s) added in Cart will appear here.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.screenWidth! * .036),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

class CartResponseWidget extends StatelessWidget {
  const CartResponseWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.lottieSrc,
    required this.buttonText,
    required this.buttonOnTap,
    this.negativeButtonOnTap,
    this.negativeButtonText,
  }) : super(key: key);

  final String title;
  final String description;
  final String lottieSrc;
  final String buttonText;
  final Function buttonOnTap;
  final Function? negativeButtonOnTap;
  final String? negativeButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
            color: Theme.of(context).colorScheme.background),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.screenWidth! * .065),
            LottieBuilder.asset(
              lottieSrc,
              repeat: false,
              width: SizeConfig.screenWidth! * .55,
              height: SizeConfig.screenWidth! * .55,
              onLoaded: (composite) async {},
            ),
            SizedBox(height: SizeConfig.screenWidth! * .045),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth! * .0415),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .015),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .0335),
              ),
            ),
            SizedBox(height: SizeConfig.screenWidth! * .075),
            Row(
              children: [
                if (negativeButtonText != null)
                  Flexible(
                    child: CustomElevatedButton(
                        buttonText: negativeButtonText!,
                        bgColor: Theme.of(context).colorScheme.error,
                        onPress: () {
                          if (negativeButtonOnTap == null) {
                            Navigator.of(context).pop();
                          } else {
                            negativeButtonOnTap!();
                          }
                        }),
                  ),
                if (negativeButtonText != null)
                  SizedBox(width: SizeConfig.screenHeight! * .015),
                Flexible(
                  child: CustomElevatedButton(
                      buttonText: buttonText,
                      onPress: () async {
                        await buttonOnTap();
                      }),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
          ],
        ),
      ),
    );
  }
}
