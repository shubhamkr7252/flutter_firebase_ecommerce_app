import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import '../../../model/category.dart';
import '../../../service/navigator_service.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_drag_handle.dart';
import '../../product listing/product_listing_screen.dart';

class AllCategoriesTile extends StatelessWidget {
  const AllCategoriesTile(
      {Key? key,
      required this.categoryModelName,
      required this.categoryModelId,
      required this.imageSrc})
      : super(key: key);

  final String categoryModelName;
  final String imageSrc;
  final String categoryModelId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBottomSheetDragHandleWithTitle(title: categoryModelName),
            Consumer<CategoriesProvider>(
              builder: (context, categoriesprovider, _) => Padding(
                padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                child: DynamicHeightGridView(
                    shrinkWrap: true,
                    mainAxisSpacing: SizeConfig.screenHeight! * .015,
                    crossAxisSpacing: SizeConfig.screenHeight! * .015,
                    physics: const NeverScrollableScrollPhysics(),
                    builder: (context, index) {
                      List<CategoryObject> data = categoriesprovider
                          .allCategoryModelData!.categories!
                          .where(
                              (element) => element.parentId == categoryModelId)
                          .toList();

                      return InkWell(
                        onTap: () {},
                        child: AllCategoriesCategoryTile(
                          name: data[index].categoryName,
                          id: data[index].categoryId,
                          imageSrc: data[index].image,
                          onTap: () {
                            NavigatorService.push(
                              context,
                              page: ProductListingScreen(
                                id: data[index].categoryId,
                                name: data[index].categoryName,
                                type: "CategoryModel",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: categoriesprovider
                        .allCategoryModelData!.categories!
                        .where((element) => element.parentId == categoryModelId)
                        .length,
                    crossAxisCount: 3),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AllCategoriesCategoryTile extends StatelessWidget {
  const AllCategoriesCategoryTile(
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
    return SizedBox(
      width: SizeConfig.screenWidth! * .25,
      child: Material(
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        color: bgColor ?? Theme.of(context).colorScheme.background,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          ),
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          highlightColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.screenHeight! * .015,
                horizontal: SizeConfig.screenHeight! * .005),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: SizeConfig.screenWidth! * .085,
                  width: SizeConfig.screenWidth! * .085,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(imageSrc))),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .025),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.screenWidth! * .0275),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
