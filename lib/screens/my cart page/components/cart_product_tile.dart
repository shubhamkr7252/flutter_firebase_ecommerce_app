import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20description%20page/product_item_page.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';

import '../../../provider/cart_provider.dart';
import '../../product listing page/components/product_list_tile.dart';

class CartProductTile extends StatelessWidget {
  const CartProductTile({
    Key? key,
    required this.productData,
    required this.isProductInWishlist,
    required this.index,
  }) : super(key: key);

  final ProductListModel productData;
  final bool isProductInWishlist;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => Consumer<CartProvider>(
        builder: (context, cartprovider, _) => Padding(
          padding: index == 0
              ? EdgeInsets.only(top: SizeConfig.screenHeight! * .015)
              : (index == cartprovider.allCartData!.products!.length - 1
                  ? EdgeInsets.only(bottom: SizeConfig.screenHeight! * .015)
                  : EdgeInsets.zero),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01),
            ),
            padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
            child: InkWell(
              onTap: () {
                NavigatorService.push(context,
                    page: ProductItemPage(product: productData));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: ProductListTile(
                    data: productData,
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(SizeConfig.screenHeight! * .01),
                        topRight:
                            Radius.circular(SizeConfig.screenHeight! * .01)),
                  )),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  Row(
                    children: [
                      if (isProductInWishlist == false)
                        Flexible(
                          child: CustomElevatedButton(
                            buttonText: isProductInWishlist
                                ? "Item in Wishlist"
                                : "Move to Wishlist",
                            textColor: Theme.of(context).colorScheme.background,
                            bgColor: isProductInWishlist
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(0.75)
                                : Theme.of(context).colorScheme.primary,
                            onPress: () async {
                              if (isProductInWishlist == false) {
                                await cartprovider.moveCartProductToWishlist(
                                    context,
                                    userId: userprovider.getCurrentUser!.id!,
                                    productData: productData);
                              } else {
                                return;
                              }
                            },
                          ),
                        ),
                      if (isProductInWishlist == false)
                        SizedBox(width: SizeConfig.screenHeight! * .015),
                      Flexible(
                        child: CustomElevatedButton(
                          buttonText: "Remove",
                          textColor: Theme.of(context).colorScheme.background,
                          bgColor: Theme.of(context).colorScheme.error,
                          onPress: () async {
                            await cartprovider.modifyList(
                                product: productData,
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
