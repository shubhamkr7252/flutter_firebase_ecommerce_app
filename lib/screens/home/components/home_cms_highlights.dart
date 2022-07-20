import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import '../../../service/navigator_service.dart';
import '../../product description/product_description_screen.dart';
import 'home_screen_product_tile.dart';

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
