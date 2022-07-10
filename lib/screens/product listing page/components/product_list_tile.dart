import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/extension/currency_extension.dart';
import 'package:flutter_firebase_ecommerce_app/theme/colors.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import '../../../model/product.dart';
import '../../../utils/discount_calculator.dart';
import '../../../widgets/custom loader/custom_loader.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    Key? key,
    required this.data,
    this.bgColor,
    this.borderRadius,
  }) : super(key: key);

  final ProductListModel data;
  final Color? bgColor;
  final BorderRadius? borderRadius;

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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight! * .015),
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
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * .0325),
                            children: List.generate(
                                data.attributes!.length,
                                (index) => TextSpan(
                                    text: data.attributes!.length > 2
                                        ? (data.attributes![index] +
                                            (index ==
                                                    data.attributes!.length - 1
                                                ? ""
                                                : ", "))
                                        : (index == 1 ? ", " : "") +
                                            data.attributes![index])),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenWidth! * .035),
                      Text.rich(TextSpan(
                        children: [
                          if (data.salePrice! != 0)
                            TextSpan(
                                text: data.price!
                                    .inCurrency()
                                    .replaceAll(".0", ""),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width * .03,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withAlpha(100),
                                    decoration: TextDecoration.lineThrough)),
                          TextSpan(
                            text: (data.salePrice! != 0
                                ? " " +
                                    data.salePrice!
                                        .inCurrency()
                                        .replaceAll(".0", "")
                                : data.price!
                                    .inCurrency()
                                    .replaceAll(".0", "")),
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
                                    color: Colors.green,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            .032,
                                    fontWeight: FontWeight.w500))
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
