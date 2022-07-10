import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import '../../../model/category.dart';
import '../../../service/navigator_service.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_drag_handle.dart';
import '../../home page/components/home_categories.dart';
import '../../product listing page/product_list.dart';

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
                        child: HomeCategoriesIconDecoration(
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
