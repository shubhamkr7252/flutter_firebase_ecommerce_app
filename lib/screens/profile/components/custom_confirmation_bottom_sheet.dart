import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_close_button.dart';
import '../../../widgets/custom_bottom_sheet_drag_handle.dart';

class CustomConfirmationBottomSheet extends StatelessWidget {
  const CustomConfirmationBottomSheet({
    Key? key,
    required this.title,
    this.description,
    this.customChild,
    required this.buttonOnTap,
    this.buttonColor,
    required this.buttonText,
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget? customChild;
  final Function buttonOnTap;
  final Color? buttonColor;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    if (customChild != null && description != null) {
      throw "customChild != null || description != null is not true.";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomBottomSheetCloseButton(),
        Padding(
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
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
                color: Theme.of(context).colorScheme.background,
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomBottomSheetDragHandleWithTitle(
                  title: title,
                ),
                SizedBox(height: SizeConfig.screenWidth! * .05),
                if (description == null && customChild != null) customChild!,
                if (description != null && customChild == null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenHeight! * .015),
                    child: Text(
                      description!,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! * .0335,
                      ),
                    ),
                  ),
                if (description != null || customChild != null)
                  SizedBox(height: SizeConfig.screenWidth! * .05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: CustomButtonA(
                      textColor:
                          buttonColor ?? Theme.of(context).colorScheme.primary,
                      buttonText: buttonText,
                      onPress: () async {
                        await buttonOnTap();
                      }),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .035),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
