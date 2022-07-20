import 'package:flutter/material.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_close_button.dart';
import '../../../widgets/custom_button_a.dart';

class CartResponseWidget extends StatelessWidget {
  const CartResponseWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.buttonOnTap,
  }) : super(key: key);

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final Function buttonOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomBottomSheetCloseButton(),
        Padding(
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.25),
                    blurRadius: 2.0,
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01),
                color: Theme.of(context).colorScheme.background),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: SizeConfig.screenWidth! * .065),
                Icon(
                  icon,
                  color: iconColor,
                  size: SizeConfig.screenHeight! * .15,
                ),
                SizedBox(height: SizeConfig.screenWidth! * .045),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.screenWidth! * .0415),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: SizeConfig.screenWidth! * .0335),
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .075),
                CustomButtonA(
                    buttonText: buttonText,
                    onPress: () async {
                      await buttonOnTap();
                    }),
                SizedBox(height: SizeConfig.screenHeight! * .015),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
