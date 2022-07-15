import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:skeletons/skeletons.dart';

import '../../../theme/colors.dart';

class WishlistLoadingTIle extends StatelessWidget {
  const WishlistLoadingTIle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: ColorOperations.shimmerGradient(context),
      child: Container(
        width: SizeConfig.screenWidth!,
        color: Theme.of(context).cardTheme.color,
        child: Row(
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  width: SizeConfig.screenWidth! * .37,
                  height: SizeConfig.screenWidth! * .37),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth! * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth!,
                        height: SizeConfig.screenWidth! * .035,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .01),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth! * 0.45,
                        height: SizeConfig.screenWidth! * .04,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .025),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth! * 0.18,
                        height: SizeConfig.screenWidth! * .06,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .025),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        width: SizeConfig.screenWidth!,
                        height: SizeConfig.screenWidth! * .09,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
