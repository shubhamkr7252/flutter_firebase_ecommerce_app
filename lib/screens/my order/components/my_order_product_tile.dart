import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_title_chip.dart';
import 'package:skeletons/skeletons.dart';

import '../../../theme/colors.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom loader/custom_loader.dart';

class MyOrderProductTile extends StatelessWidget {
  const MyOrderProductTile({
    Key? key,
    required this.data,
    this.orderStatus,
  }) : super(key: key);

  final ProductListModel data;
  final int? orderStatus;

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: ColorOperations.shimmerGradient(context),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .015),
            child: Container(
              color: Colors.white,
              height: SizeConfig.screenWidth! * .25,
              width: SizeConfig.screenWidth! * .25,
              child: data.images != null
                  ? Padding(
                      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                      child: CachedNetworkImage(
                        imageUrl: data.images!.first,
                        fit: BoxFit.contain,
                        placeholder: (context, placeholderWidget) =>
                            CustomLoader(
                          color: Theme.of(context).colorScheme.primary,
                          size: SizeConfig.screenHeight! * .05,
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset("assets/no-pic.png",
                          color: Theme.of(context).colorScheme.primary,
                          width: SizeConfig.screenWidth! * .3)),
            ),
          ),
          SizedBox(width: SizeConfig.screenWidth! * .045),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.name!,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth! * .0365,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text.rich(
                    TextSpan(
                      style:
                          TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
                      children: List.generate(
                          data.attributes!.length,
                          (index) => TextSpan(
                              text: data.attributes!.length > 2
                                  ? (data.attributes![index] +
                                      (index == data.attributes!.length - 1
                                          ? ""
                                          : ", "))
                                  : (index == 1 ? ", " : "") +
                                      data.attributes![index])),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (orderStatus != null)
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                if (orderStatus != null)
                  CustomTitleChip(
                      text: getOrderStatus(orderStatus!),
                      bgColor: orderStatus == 4
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary)
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getOrderStatus(int statusId) {
    if (statusId == 0) {
      return "Order Placed";
    }
    if (statusId == 1) {
      return "Shipped";
    }
    if (statusId == 2) {
      return "Out for Delivery";
    }
    if (statusId == 3) {
      return "Delivered";
    }
    if (statusId == 4) {
      return "Cancelled";
    }
    return "";
  }
}
