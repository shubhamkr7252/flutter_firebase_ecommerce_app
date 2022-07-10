import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20description%20page/product_item_page.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20listing%20page/components/product_list_tile.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/theme/colors.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';

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
        builder: (context, currentUser, _) => Consumer<CartProvider>(
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/wishlist_blank.png",
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
                            "Wishlist is empty",
                            style: TextStyle(
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth! * .045),
                          ),
                          SizedBox(height: SizeConfig.screenWidth! * .01),
                          Opacity(
                            opacity: 0.75,
                            child: Text(
                              "Go back and add some items to wishlist and come back here.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! * .036),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

class WishlistProductTile extends StatelessWidget {
  const WishlistProductTile({
    Key? key,
    required this.data,
    required this.isProductInCart,
    required this.index,
  }) : super(key: key);

  final ProductListModel data;
  final bool isProductInCart;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, _) => Padding(
          padding: index == 0
              ? EdgeInsets.only(top: SizeConfig.screenHeight! * .015)
              : (index == wishlistprovider.allWishlistProducts.length - 1
                  ? EdgeInsets.only(bottom: SizeConfig.screenHeight! * .015)
                  : EdgeInsets.zero),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .015),
            ),
            padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
            child: InkWell(
              onTap: () {
                NavigatorService.push(context,
                    page: ProductItemPage(product: data));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: ProductListTile(
                    data: data,
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(SizeConfig.screenHeight! * .01),
                        topRight:
                            Radius.circular(SizeConfig.screenHeight! * .01)),
                  )),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  Row(
                    children: [
                      Flexible(
                        child: CustomElevatedButton(
                          buttonText:
                              isProductInCart ? "Item in Cart" : "Move to Cart",
                          textColor: Theme.of(context).colorScheme.background,
                          bgColor: isProductInCart
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.75)
                              : Theme.of(context).colorScheme.primary,
                          onPress: () async {
                            if (isProductInCart == false) {
                              await wishlistprovider.moveWishlistProductToCart(
                                  context,
                                  userId: userprovider.getCurrentUser!.id!,
                                  productData: data);
                            } else {
                              return;
                            }
                          },
                        ),
                      ),
                      SizedBox(width: SizeConfig.screenHeight! * .015),
                      Flexible(
                        child: CustomElevatedButton(
                          buttonText: "Remove",
                          textColor: Theme.of(context).colorScheme.background,
                          bgColor: Theme.of(context).colorScheme.error,
                          onPress: () async {
                            await wishlistprovider.removeItem(data,
                                userId: userprovider.getCurrentUser!.id!);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WishlistLoadingTIle extends StatelessWidget {
  const WishlistLoadingTIle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: ColorOperations.shimmerGradient(context),
      child: Container(
        width: SizeConfig.screenWidth!,
        color: Theme.of(context).cardTheme.color,
        child: Row(
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: SizeConfig.screenWidth! * .37,
                  height: SizeConfig.screenWidth! * .37),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth! * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth!,
                        height: SizeConfig.screenWidth! * .035,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .01),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth! * 0.45,
                        height: SizeConfig.screenWidth! * .04,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .025),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth! * 0.18,
                        height: SizeConfig.screenWidth! * .06,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .025),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth!,
                        height: SizeConfig.screenWidth! * .09,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
