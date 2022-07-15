import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/my_cart_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20description/product_description_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/search/search_screen.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/provider/products_provider.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';
import 'components/product_list_tile.dart';

class ProductListingScreen extends StatefulWidget {
  final String id;
  final String name;
  final String type;
  const ProductListingScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.type,
  }) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late ProductProvider _productProvider;

  @override
  void initState() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.resetData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.type == "CategoryModel") {
        _productProvider.fetchCategoryProductsData(categoryId: widget.id);
      }
      if (widget.type == "Brand") {
        _productProvider.fetchBrandProductsData(brandId: widget.id);
      }
      if (widget.type == "Search") {
        _productProvider.fetchSearchQueryResultProductData(query: widget.id);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: widget.name,
      appBarActions: [
        IconButton(
            onPressed: () {
              NavigatorService.push(
                context,
                page: const MyCartScreen(
                  showAppbar: true,
                ),
              );
            },
            icon: const Icon(
              FlutterRemix.shopping_bag_2_fill,
            )),
        IconButton(
            onPressed: () {
              if (widget.type == "Search") {
                Navigator.of(context).pop();
              } else {
                NavigatorService.push(context, page: const SearchScreen());
              }
            },
            icon: const Icon(
              FlutterRemix.search_2_fill,
            )),
      ],
      body:
          Consumer<ProductProvider>(builder: (context, productprovider, child) {
        if (productprovider.allProductsData.isEmpty &&
            productprovider.isDataLoaded == true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/no_data.png",
                  width: SizeConfig.screenWidth! * .35,
                  color:
                      Theme.of(context).colorScheme.secondary.withAlpha(150)),
              SizedBox(height: SizeConfig.screenWidth! * .05),
              Text("No Product(s) Found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.screenWidth! * .045)),
              Text(
                "Please go back and select a different ${widget.type == "Brand" ? "Brand" : (widget.type == "Search" ? "search query" : "category")} or try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .036),
              ),
            ],
          );
        } else if (productprovider.allProductsData.isNotEmpty &&
            productprovider.isDataLoaded == true) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Scrollbar(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: SizeConfig.screenHeight! * .015),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                top: SizeConfig.screenHeight! * .015)
                            : (index ==
                                    productprovider.allProductsData.length - 1
                                ? EdgeInsets.only(
                                    bottom: SizeConfig.screenHeight! * .015)
                                : EdgeInsets.zero),
                        child: Container(
                          padding:
                              EdgeInsets.all(SizeConfig.screenHeight! * .015),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight! * .01),
                          ),
                          child: InkWell(
                              onTap: () {
                                NavigatorService.push(context,
                                    page: ProductDescriptionScreen(
                                        product: productprovider
                                            .allProductsData[index]));
                              },
                              child: ProductListTile(
                                  data:
                                      productprovider.allProductsData[index])),
                        ),
                      );
                    },
                    itemCount: productprovider.allProductsData.length,
                  ),
                ),
                // Positioned.fill(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: AnimatedSlide(
                //       offset: !productprovider.isDataLoaded
                //           ? const Offset(0, 0)
                //           : const Offset(0, 1),
                //       duration: const Duration(milliseconds: 300),
                //       child: CustomLoadingIndicator(
                //           indicatorSize: SizeConfig.screenWidth! * .055),
                //     ),
                //   ),
                // )
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .03),
            child: const CustomLoadingIndicator(indicatorSize: 20.0),
          );
        }
      }),
    );
  }

//   Future<dynamic> bottomSortOptions(BuildContext context) {
//     return showModalBottomSheet(
//         context: context,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         builder: (_) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setModalState) {
//             return Padding(
//               padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.background,
//                   borderRadius:
//                       BorderRadius.circular(SizeConfig.screenHeight! * .01),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.screenHeight! * .015),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CustomBottomSheetDragHandleWithTitle(),
//                       SizedBox(height: SizeConfig.screenWidth! * .025),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: SizeConfig.screenHeight! * .015,
//                                 vertical: SizeConfig.screenHeight! * .01),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                     SizeConfig.screenHeight! * .01),
//                                 color: Theme.of(context).colorScheme.secondary),
//                             child: Text(
//                               "Sort By",
//                               style: TextStyle(
//                                 color: Theme.of(context).colorScheme.background,
//                                 fontSize: SizeConfig.screenWidth! * .035,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: SizeConfig.screenWidth! * .05),
//                           ListView.separated(
//                             itemCount: _sortByOptions.length,
//                             shrinkWrap: true,
//                             primary: false,
//                             itemBuilder: (context, index) {
//                               return InkWell(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 onTap: () {
//                                   setState(() {
//                                     _selectedSortTypeGlobal =
//                                         _sortByOptions[index];
//                                   });

//                                   var ProductListingScreen =
//                                       Provider.of<ProductProvider>(context,
//                                           listen: false);
//                                   // ProductListingScreen.resetStreams();
//                                   // ProductListingScreen
//                                   //     .setSortOrder(_selectedSortTypeGlobal);
//                                   // ProductListingScreen.callListener();
//                                   // ProductListingScreen
//                                   //     .setLoadingState(LoadMoreStatus.INITIAL);
//                                   // if (widget.type == "CategoryModel") {
//                                   //   ProductListingScreen.fetchProducts(_page,
//                                   //       categoryModelId: widget.id);
//                                   // } else if (widget.type == "Deals") {
//                                   //   ProductListingScreen.fetchProducts(_page,
//                                   //       tagId: widget.id);
//                                   // } else if (widget.type == "Search") {
//                                   //   ProductListingScreen.fetchProducts(++_page,
//                                   //       searchText: widget.id);
//                                   // }
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                         child:
//                                             Text(_sortByOptions[index].text)),
//                                     Icon(
//                                       _selectedSortTypeGlobal ==
//                                               _sortByOptions[index]
//                                           ? FlutterRemix.checkbox_fill
//                                           : FlutterRemix.checkbox_line,
//                                       color: _selectedSortTypeGlobal ==
//                                               _sortByOptions[index]
//                                           ? Theme.of(context)
//                                               .colorScheme
//                                               .secondary
//                                           : Theme.of(context)
//                                               .colorScheme
//                                               .secondary
//                                               .withOpacity(0.5),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return SizedBox(
//                                   height: SizeConfig.screenHeight! * .015);
//                             },
//                           )
//                         ],
//                       ),
//                       SizedBox(height: SizeConfig.screenWidth! * .025),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }
}
