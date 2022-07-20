import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final ProductListModel data;
  final Function onTap;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) =>
          Consumer<WishlistProvider>(builder: (context, wishlistprovider, _) {
        bool _isProductWishlisted = wishlistprovider.allWishlistProducts
            .where((element) => element.id == widget.data.id)
            .isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: _isProductWishlisted
                ? Colors.red.withOpacity(0.25)
                : Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(SizeConfig.screenWidth! * .03),
          child: _isLoading == false
              ? InkResponse(
                  onTap: () async {
                    if (userprovider.getCurrentUser != null) {
                      setState(() {
                        _isLoading = true;
                      });

                      await wishlistprovider.modifyList(widget.data,
                          userId: userprovider.getCurrentUser!.id.toString());

                      setState(() {
                        _isLoading = false;
                      });

                      if (wishlistprovider.allWishlistProducts
                          .contains(widget.data)) {
                        CustomSnackbar.showSnackbar(
                          context,
                          title: "Item added to wishlist",
                          type: 1,
                        );
                      } else {
                        CustomSnackbar.showSnackbar(
                          context,
                          title: "Item removed from wishlist",
                          type: 2,
                        );
                      }
                    } else {
                      CustomSnackbar.showSnackbar(
                        context,
                        title: "Please login to use wishlist",
                        type: 2,
                      );
                    }
                  },
                  child: Icon(
                    _isProductWishlisted == true
                        ? FlutterRemix.heart_3_fill
                        : FlutterRemix.heart_3_line,
                    size: SizeConfig.screenWidth! * .075,
                    color: _isProductWishlisted == true
                        ? Colors.red
                        : Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withAlpha(100),
                  ),
                )
              : SizedBox(
                  height: SizeConfig.screenWidth! * .07,
                  width: SizeConfig.screenWidth! * .075,
                  child: CustomLoader(
                    color: Theme.of(context).colorScheme.secondary,
                    size: SizeConfig.screenWidth! * .075,
                  ),
                ),
        );
      }),
    );
  }
}
