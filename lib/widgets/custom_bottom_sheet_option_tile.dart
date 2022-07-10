import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class CustomBottomSheetOptionTile extends StatelessWidget {
  const CustomBottomSheetOptionTile({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final Color backgroundColor;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .01),
        child: Container(
            padding: EdgeInsets.all(SizeConfig.screenHeight! * 0.02),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.background),
                SizedBox(width: SizeConfig.screenWidth! * .02),
                Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
              ],
            )));
  }
}
