import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/products_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20description%20page/components/category_chips.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/discount_calculator.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';
import '../../provider/user_provider.dart';
import '../../provider/wishlist_provider.dart';
import '../../widgets/custom_loading_indicator.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/product_variants.dart';
import 'components/wishlist_button.dart';

class ProductItemPage extends StatefulWidget {
  const ProductItemPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductListModel product;

  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

class _ProductItemPageState extends State<ProductItemPage> {
  late ScrollController _scrollController;

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

    _scrollController = ScrollController();
    // _scrollController.addListener(() {
    // if (_scrollController.position.userScrollDirection ==
    //     ScrollDirection.reverse) {
    //   if (_isVisible == true) {
    //     setState(() {
    //       _isVisible = false;
    //     });
    //   }
    // } else {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     if (_isVisible == false) {
    //       setState(() {
    //         _isVisible = true;
    //       });
    //     }
    //   }
    // }
    // });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          body: SingleChildScrollView(
              controller: _scrollController,
              child: Consumer<ProductProvider>(
                  builder: (context, productprovider, _) {
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
                                        fontSize:
                                            SizeConfig.screenWidth! * .04),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenWidth! * .01),
                                  Opacity(
                                    opacity: 0.5,
                                    child: Text.rich(
                                      TextSpan(
                                        children: List.generate(
                                            productprovider.productData!
                                                .attributes!.length,
                                            (index) => TextSpan(
                                                text: productprovider
                                                            .productData!
                                                            .attributes!
                                                            .length >
                                                        2
                                                    ? (productprovider.productData!.attributes![index] +
                                                        (index ==
                                                                productprovider
                                                                        .productData!
                                                                        .attributes!
                                                                        .length -
                                                                    1
                                                            ? ""
                                                            : ", "))
                                                    : (index == 1 ? ", " : "") +
                                                        productprovider
                                                            .productData!
                                                            .attributes![index])),
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenWidth! * .01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
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
                                        (productprovider.productData!
                                                        .salePrice! !=
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
                                                            .productData!
                                                            .salePrice!
                                                            .toString(),
                                                        productprovider
                                                            .productData!.price!
                                                            .toString()) +
                                                " OFF",
                                            style: TextStyle(
                                                color: Colors.green,
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
                                              userId: currentUser
                                                  .getCurrentUser!.id
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
                          bool isProductInCart = cartprovider
                              .allCartData!.products!
                              .where(
                                  (element) => element.id == widget.product.id)
                              .isNotEmpty;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenHeight! * .015),
                            child: CustomElevatedButton(
                                bgColor: isProductInCart
                                    ? MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.green[300]
                                        : Colors.green
                                    : Theme.of(context).colorScheme.primary,
                                buttonText: isProductInCart
                                    ? "Added to Cart"
                                    : "Add to Cart",
                                textColor:
                                    Theme.of(context).colorScheme.background,
                                onPress: () async {
                                  if (isProductInCart) {
                                    return;
                                  } else {
                                    await cartprovider.modifyList(
                                        product: widget.product,
                                        userId:
                                            userprovider.getCurrentUser!.id!);
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
                        child: Container(
                          padding:
                              EdgeInsets.all(SizeConfig.screenHeight! * .015),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight! * .01),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenHeight! * .015,
                                    vertical: SizeConfig.screenHeight! * .01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.screenHeight! * .01),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: Text(
                                  "Refund Policy",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: SizeConfig.screenWidth! * .035,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenHeight! * .015),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("\u2022 "),
                                          Expanded(
                                              child: Text(index == 0
                                                  ? "10 Days Replacement Policy"
                                                  : "GST invoice available")),
                                        ],
                                      ),
                                  itemCount: 2),
                            ],
                          ),
                        ),
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
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight! * .025),
                        child:
                            const CustomLoadingIndicator(indicatorSize: 20)));
              })),
        ),
      ),
    );
  }
}
