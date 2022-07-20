import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/utils/cart_color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/products_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/discount_calculator.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import '../../provider/user_provider.dart';
import '../../provider/wishlist_provider.dart';
import '../../widgets/custom_loading_indicator.dart';
import 'components/category_chips.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/product_variants.dart';
import 'components/refund_policy.dart';
import 'components/wishlist_button.dart';

class ProductDescriptionScreen extends StatefulWidget {
  const ProductDescriptionScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductListModel product;

  @override
  State<ProductDescriptionScreen> createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {
  late SearchProvider _searchProvider;
  late ProductProvider _productProvider;

  @override
  void initState() {
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);

    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.setDataLoading();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productProvider.fetchProductData(productId: widget.product.id!);
      _searchProvider.addPreviousProductData(productData: widget.product);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Brightness.light
                : Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(child:
              Consumer<ProductProvider>(builder: (context, productprovider, _) {
            if (productprovider.isDataLoaded == true &&
                productprovider.productData != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductImages(
                      imageData: productprovider.productData!.images!),
                  if (productprovider.productData!.categories != null &&
                      productprovider.productData!.categories!.isNotEmpty)
                    CategoriesChips(
                        data: productprovider.productData!.categories!),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenHeight! * .015,
                        vertical: SizeConfig.screenHeight! * .01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productprovider.productData!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.screenWidth! * .04),
                              ),
                              SizedBox(height: SizeConfig.screenWidth! * .01),
                              Opacity(
                                opacity: 0.5,
                                child: Text.rich(
                                  TextSpan(
                                    children: List.generate(
                                        productprovider
                                            .productData!.attributes!.length,
                                        (index) => TextSpan(
                                            text: productprovider.productData!
                                                        .attributes!.length >
                                                    2
                                                ? (productprovider.productData!
                                                        .attributes![index] +
                                                    (index ==
                                                            productprovider
                                                                    .productData!
                                                                    .attributes!
                                                                    .length -
                                                                1
                                                        ? ""
                                                        : ", "))
                                                : (index == 1 ? ", " : "") +
                                                    productprovider.productData!
                                                        .attributes![index])),
                                  ),
                                  maxLines: null,
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenWidth! * .01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Visibility(
                                      child: Text(
                                        productprovider.productData!.price!
                                                .inCurrency()
                                                .replaceAll(".0", "") +
                                            " ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .04,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color!
                                                .withAlpha(100),
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      visible: productprovider
                                              .productData!.salePrice! !=
                                          0),
                                  Text(
                                    (productprovider.productData!.salePrice! !=
                                                0
                                            ? productprovider
                                                .productData!.salePrice!
                                                .inCurrency()
                                                .replaceAll(".0", "")
                                            : productprovider
                                                .productData!.price!)
                                        .toString()
                                        .replaceAll(".0", ""),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.screenWidth! * .055),
                                  ),
                                  Visibility(
                                      child: Text(
                                        " " +
                                            DiscountCalculator
                                                .calculateDiscount(
                                                    productprovider
                                                        .productData!.salePrice!
                                                        .toString(),
                                                    productprovider
                                                        .productData!.price!
                                                        .toString()) +
                                            " OFF",
                                        style: TextStyle(
                                            color: CartColor.getColor(context),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .035,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      visible: productprovider
                                              .productData!.salePrice! !=
                                          0),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Consumer<UserProvider>(
                          builder: (context, currentUser, _) =>
                              Consumer<WishlistProvider>(
                            builder: (context, wishlistprovider, _) =>
                                WishlistButton(
                                    data: widget.product,
                                    onTap: () async {
                                      wishlistprovider.modifyList(
                                          widget.product,
                                          userId: currentUser.getCurrentUser!.id
                                              .toString());
                                    }),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (productprovider.productData!.variants!.isNotEmpty)
                    ProductVariantsComponent(
                        data: productprovider.productData!.variants!),
                  Consumer<UserProvider>(
                    builder: (context, userprovider, _) =>
                        Consumer<CartProvider>(
                            builder: (context, cartprovider, _) {
                      bool isProductInCart = cartprovider.allCartData!.products!
                          .where((element) => element.id == widget.product.id)
                          .isNotEmpty;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenHeight! * .015),
                        child: CustomButtonA(
                            textColor: isProductInCart
                                ? CartColor.getColor(context)
                                : Theme.of(context).colorScheme.primary,
                            buttonText: isProductInCart
                                ? "Added to Cart"
                                : "Add to Cart",
                            onPress: () async {
                              if (isProductInCart) {
                                return;
                              } else {
                                await cartprovider.modifyList(
                                    product: widget.product,
                                    userId: userprovider.getCurrentUser!.id!);
                              }
                            }),
                      );
                    }),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  ProductDescription(
                      data: productprovider.productData!.description!),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenHeight! * .015),
                    child: const ProductDescriptionRefundPolicy(),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                ],
              );
            } else if (productprovider.isDataLoaded == true &&
                productprovider.productData == null) {
              return const SizedBox();
            }
            return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight! * .025),
                    child: const CustomLoadingIndicator(indicatorSize: 20)));
          })),
        ),
      ),
    );
  }
}
