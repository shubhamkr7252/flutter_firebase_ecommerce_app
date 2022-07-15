import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/model/category.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import '../../../service/navigator_service.dart';
import '../../product listing/product_listing_screen.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  _HomeCategoriesState createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  late CategoriesProvider _categoriesProvider;
  @override
  void initState() {
    _categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_categoriesProvider.isDataLoaded == false) {
        _categoriesProvider.fetchCategoryModelData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
        builder: (context, categoriesprovider, _) {
      if (categoriesprovider.allCategoryModelData != null &&
          categoriesprovider.allCategoryModelData!.categories!.isNotEmpty &&
          categoriesprovider.isDataLoaded == true) {
        List<CategoryObject> _topCategories = categoriesprovider
            .allCategoryModelData!.categories!
            .where((firstElement) => categoriesprovider
                .allCategoryModelData!.top!
                .where((element) => element == firstElement.categoryId)
                .isNotEmpty)
            .toList();

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const CustomBottomSheetDragHandleWithTitle(
                        title: "Top Categories"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight! * .015),
                        child: Row(
                          children: List.generate(
                            categoriesprovider
                                .allCategoryModelData!.top!.length,
                            (index) => Padding(
                              padding: index ==
                                      categoriesprovider.allCategoryModelData!
                                              .top!.length -
                                          1
                                  ? EdgeInsets.only(
                                      left: SizeConfig.screenHeight! * .015,
                                      right: SizeConfig.screenHeight! * .015)
                                  : EdgeInsets.only(
                                      left: SizeConfig.screenHeight! * .015),
                              child: HomeCategoriesIconDecoration(
                                id: _topCategories[index].categoryId,
                                name: _topCategories[index].categoryName,
                                imageSrc: _topCategories[index].image,
                                onTap: () {
                                  NavigatorService.push(
                                    context,
                                    page: ProductListingScreen(
                                      id: _topCategories[index].categoryId,
                                      name: _topCategories[index].categoryName,
                                      type: "CategoryModel",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.only(
            right: SizeConfig.screenHeight! * .015,
            left: SizeConfig.screenHeight! * .015,
            top: SizeConfig.screenHeight! * .015),
        height: SizeConfig.screenWidth! * .25,
        width: SizeConfig.screenWidth!,
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        ),
      );
    });
  }
}

class HomeCategoriesIconDecoration extends StatelessWidget {
  const HomeCategoriesIconDecoration(
      {Key? key,
      required this.id,
      required this.name,
      required this.imageSrc,
      required this.onTap,
      this.bgColor})
      : super(key: key);

  final String id, name, imageSrc;
  final Function onTap;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
      color: bgColor ?? Theme.of(context).colorScheme.background,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        ),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.screenHeight! * .015,
              horizontal: SizeConfig.screenHeight! * .015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: SizeConfig.screenWidth! * .065,
                width: SizeConfig.screenWidth! * .065,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(imageSrc))),
              ),
              SizedBox(width: SizeConfig.screenWidth! * .025),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .03215),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
