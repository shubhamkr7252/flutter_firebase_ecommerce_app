import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/model/brand.dart';
import 'package:flutter_firebase_ecommerce_app/provider/brands_provider.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import '../../../service/navigator_service.dart';
import '../../../theme/size.dart';
import '../../product listing/product_listing_screen.dart';
import 'home_categories.dart';

class HomeBrands extends StatefulWidget {
  const HomeBrands({Key? key}) : super(key: key);

  @override
  State<HomeBrands> createState() => _HomeBrandsState();
}

class _HomeBrandsState extends State<HomeBrands> {
  late BrandsProvider _brandsProvider;

  @override
  void initState() {
    _brandsProvider = Provider.of<BrandsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_brandsProvider.isDataLoaded == false) {
        _brandsProvider.fetchCategoryModelData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandsProvider>(builder: (context, brandsprovider, _) {
      if (brandsprovider.isDataLoaded == true &&
          brandsprovider.allBrandsData!.brands!.isNotEmpty) {
        List<BrandObject> _topBrands = brandsprovider.allBrandsData!.brands!
            .where((firstElement) => brandsprovider.allBrandsData!.top!
                .where((element) => element == firstElement.brandId)
                .isNotEmpty)
            .toList();
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
                const CustomBottomSheetDragHandleWithTitle(title: "Top Brands"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight! * .015),
                    child: Row(
                      children: List.generate(
                        _topBrands.length,
                        (index) => Padding(
                          padding: index == _topBrands.length - 1
                              ? EdgeInsets.only(
                                  left: SizeConfig.screenHeight! * .015,
                                  right: SizeConfig.screenHeight! * .015)
                              : EdgeInsets.only(
                                  left: SizeConfig.screenHeight! * .015),
                          child: HomeCategoriesIconDecoration(
                            id: _topBrands[index].brandId!,
                            name: _topBrands[index].name!,
                            imageSrc: _topBrands[index].image!,
                            onTap: () {
                              NavigatorService.push(
                                context,
                                page: ProductListingScreen(
                                  id: _topBrands[index].brandId!,
                                  name: _topBrands[index].name!,
                                  type: "Brand",
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
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
