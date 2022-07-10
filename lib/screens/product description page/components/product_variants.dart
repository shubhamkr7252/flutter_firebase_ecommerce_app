import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';

import '../../../theme/size.dart';

class ProductVariantsComponent extends StatelessWidget {
  const ProductVariantsComponent({Key? key, required this.data})
      : super(key: key);

  final List<ProductVariantObject> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .015,
                  vertical: SizeConfig.screenHeight! * .01),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  color: Theme.of(context).colorScheme.secondary),
              child: Text(
                "Color",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: SizeConfig.screenWidth! * .035,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            Wrap(
              children: List.generate(
                  data.length,
                  (index) => SizedBox(
                        width: SizeConfig.screenHeight! * .115,
                        child: Column(
                          children: [
                            Container(
                              width: SizeConfig.screenWidth! * .25,
                              height: SizeConfig.screenWidth! * .25,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          data[index].image!)),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.screenHeight! * .01)),
                            ),
                            SizedBox(height: SizeConfig.screenHeight! * .015),
                            Text(
                              data[index].color!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
