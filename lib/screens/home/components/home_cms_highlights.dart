import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/cart_color.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import '../../../../utils/discount_calculator.dart';
import '../../../service/navigator_service.dart';
import '../../product description/product_description_screen.dart';

class HomeCMSHighlightsComponent extends StatelessWidget {
  const HomeCMSHighlightsComponent({Key? key, required this.data})
      : super(key: key);

  final HomeCMSHighlightsModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBottomSheetDragHandleWithTitle(title: data.name!),
            Scrollable(
              semanticChildCount: 0,
              axisDirection: AxisDirection.down,
              viewportBuilder: (_, __) =>
                  NotificationListener<OverscrollNotification>(
                onNotification: (notification) =>
                    notification.metrics.axisDirection != AxisDirection.down,
                child: SingleChildScrollView(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight! * .015),
                    child: Row(
                      children: List.generate(
                          data.products!.length,
                          (index) => Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        left: SizeConfig.screenHeight! * .015,
                                        right: SizeConfig.screenHeight! * .015)
                                    : EdgeInsets.only(
                                        right: SizeConfig.screenHeight! * .015),
                                child: InkWell(
                                  onTap: () {
                                    NavigatorService.push(context,
                                        page: ProductDescriptionScreen(
                                          product: data.products![index],
                                        ));
                                  },
                                  child: HomeScreenProductTile(
                                    data: data.products![index],
                                  ),
                                ),
                              )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenProductTile extends StatelessWidget {
  const HomeScreenProductTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ProductListModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Container(
              height: SizeConfig.screenWidth! * .4,
              width: SizeConfig.screenWidth! * .4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(data.images![0]))),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.screenHeight! * .015,
                right: SizeConfig.screenHeight! * .015,
                bottom: SizeConfig.screenHeight! * .015,
                top: SizeConfig.screenHeight! * .005),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth! * .35,
                  height: SizeConfig.screenWidth! * .115,
                  child: Text(
                    data.name!,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * .035,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .035),
                Text.rich(TextSpan(
                  children: [
                    if (data.salePrice! != 0)
                      TextSpan(
                          text: data.price!.inCurrency().replaceAll(".0", ""),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: MediaQuery.of(context).size.width * .03,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withAlpha(100),
                              decoration: TextDecoration.lineThrough)),
                    TextSpan(
                      text: (data.salePrice! != 0
                          ? " " +
                              data.salePrice!.inCurrency().replaceAll(".0", "")
                          : data.price!.inCurrency().replaceAll(".0", "")),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth! * .045),
                    ),
                    if (data.salePrice! != 0)
                      TextSpan(
                          text: " " +
                              DiscountCalculator.calculateDiscount(
                                  data.salePrice!.toString(),
                                  data.price!.toString()),
                          style: TextStyle(
                              color: CartColor.getColor(context),
                              fontSize:
                                  MediaQuery.of(context).size.width * .032,
                              fontWeight: FontWeight.w500))
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
