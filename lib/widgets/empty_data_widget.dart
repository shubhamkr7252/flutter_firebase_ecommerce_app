import 'package:flutter/material.dart';

import '../theme/size.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    Key? key,
    required this.assetImage,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  final String assetImage;
  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetImage,
              width: SizeConfig.screenWidth! * .4,
              color: Theme.of(context).colorScheme.secondary.withAlpha(150)),
          SizedBox(height: SizeConfig.screenHeight! * .025),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * .1),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.screenWidth! * .045),
                ),
                if (subTitle != null)
                  SizedBox(height: SizeConfig.screenWidth! * .005),
                if (subTitle != null)
                  Opacity(
                    opacity: 0.75,
                    child: Text(
                      subTitle!,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: SizeConfig.screenWidth! * .036),
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
