import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/model/category.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/all%20categories/components/all_categories_tile.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
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
    return Scaffold(
      body:
          Consumer<CategoriesProvider>(builder: (context, categoryprovider, _) {
        if (categoryprovider.allCategoryModelData != null &&
            categoryprovider.allCategoryModelData!.categories!.isNotEmpty &&
            categoryprovider.isDataLoaded == true) {
          return ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: categoryprovider.allCategoryModelData!.categories!
                .where((element) => element.parentId == "")
                .length,
            itemBuilder: (context, index) {
              if (categoryprovider
                      .allCategoryModelData!.categories![index].parentId ==
                  "") {
                CategoryObject data =
                    categoryprovider.allCategoryModelData!.categories![index];
                return Padding(
                  padding: index ==
                          categoryprovider
                                  .allCategoryModelData!.categories!.length -
                              1
                      ? EdgeInsets.only(bottom: SizeConfig.screenHeight! * .015)
                      : (index == 0
                          ? EdgeInsets.only(
                              top: SizeConfig.screenHeight! * .015)
                          : EdgeInsets.zero),
                  child: AllCategoriesTile(
                    categoryModelId: data.categoryId.toString(),
                    categoryModelName: data.categoryName,
                    imageSrc: data.image,
                  ),
                );
              }
              return const SizedBox();
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: SizeConfig.screenHeight! * .015);
            },
          );
        }
        return ListView.separated(
          itemCount: SizeConfig.screenWidth! ~/ .25,
          itemBuilder: (context, index) => SkeletonLine(
            style: SkeletonLineStyle(
              height: SizeConfig.screenWidth! * .25,
              width: SizeConfig.screenWidth!,
            ),
          ),
          separatorBuilder: (context, index) =>
              SizedBox(height: SizeConfig.screenWidth! * .03),
        );
      }),
    );
  }
}
