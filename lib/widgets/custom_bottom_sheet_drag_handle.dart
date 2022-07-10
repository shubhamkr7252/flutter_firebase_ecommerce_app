import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class CustomBottomSheetDragHandleWithTitle extends StatelessWidget {
  const CustomBottomSheetDragHandleWithTitle(
      {Key? key, this.radius, this.bgColor, this.handleColor, this.title})
      : super(key: key);

  final BorderRadius? radius;
  final Color? bgColor;
  final Color? handleColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth!,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius:
              radius ?? BorderRadius.circular(SizeConfig.screenHeight! * .01)
          // BorderRadius.only(
          //     topLeft: Radius.circular(SizeConfig.screenHeight! * .01),
          //     topRight: Radius.circular(SizeConfig.screenHeight! * .01)),
          ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! * .01),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   height: SizeConfig.screenWidth! * .01,
          //   width: SizeConfig.screenHeight! * .05,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(SizeConfig.screenWidth!),
          //     color: Theme.of(context).colorScheme.background,
          //   ),
          // ),
          // if (title != null) SizedBox(height: SizeConfig.screenHeight! * .015),
          if (title != null)
            Container(
              width: SizeConfig.screenWidth!,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SizeConfig.screenHeight! * .01),
                  bottomRight: Radius.circular(SizeConfig.screenHeight! * .01),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! * .0345),
              ),
            ),
        ],
      ),
    );
  }
}
