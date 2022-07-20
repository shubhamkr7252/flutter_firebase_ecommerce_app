import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';

import '../../../model/product.dart';
import '../../../theme/size.dart';
import '../../../utils/cart_color.dart';
import '../../../utils/discount_calculator.dart';
import '../../../widgets/custom loader/custom_loader.dart';

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
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                child: CachedNetworkImage(
                  imageUrl: data.images!.first,
                  fit: BoxFit.contain,
                  placeholder: (context, placeholderImage) => CustomLoader(
                    color: Theme.of(context).colorScheme.primary,
                    size: SizeConfig.screenWidth! * .15,
                  ),
                ),
              ),
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
