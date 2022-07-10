import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double indicatorSize;
  const CustomLoadingIndicator({
    Key? key,
    required this.indicatorSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          color: Theme.of(context).colorScheme.secondary),
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight! * .01,
          horizontal: SizeConfig.screenHeight! * .015),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: indicatorSize,
            width: indicatorSize,
            child: CustomLoader(
              color: Theme.of(context).colorScheme.background,
              size: indicatorSize,
            ),
          ),
          SizedBox(width: SizeConfig.screenWidth! * .033),
          Text(
            "Loading",
            style: TextStyle(
                fontSize: indicatorSize - 7.5,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.background),
          ),
        ],
      ),
    );
  }
}
