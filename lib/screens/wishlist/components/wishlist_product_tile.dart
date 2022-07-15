import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../../provider/wishlist_provider.dart';
import '../../../service/navigator_service.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_button_a.dart';
import '../../product description/product_description_screen.dart';
import '../../product listing/components/product_list_tile.dart';

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
                    page: ProductDescriptionScreen(product: data));
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
                        child: CustomButtonA(
                          buttonText:
                              isProductInCart ? "Item in Cart" : "Move to Cart",
                          textColor: isProductInCart
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
                        child: CustomButtonA(
                          buttonText: "Remove",
                          textColor: Theme.of(context).colorScheme.error,
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
