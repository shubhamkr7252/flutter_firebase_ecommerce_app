import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';

import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_drag_handle.dart';

class CustomConfirmationBottomSheet extends StatelessWidget {
  const CustomConfirmationBottomSheet({
    Key? key,
    required this.title,
    this.description,
    this.customChild,
    required this.positiveButtonOnTap,
    this.positiveButtonColor,
    this.negativeButtonColor,
    required this.positiveButtonText,
    this.negativeButtonText,
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget? customChild;
  final Function positiveButtonOnTap;
  final Color? positiveButtonColor;
  final Color? negativeButtonColor;
  final String positiveButtonText;
  final String? negativeButtonText;

  @override
  Widget build(BuildContext context) {
    if (customChild != null && description != null) {
      throw "customChild != null || description != null is not true.";
    }

    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
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
              child: Row(
                children: [
                  Expanded(
                      child: CustomButtonA(
                          buttonText: negativeButtonText ?? "Cancel",
                          textColor: negativeButtonColor ??
                              Theme.of(context).colorScheme.error,
                          onPress: () {
                            Navigator.of(context).pop();
                          })),
                  SizedBox(
                    width: SizeConfig.screenWidth! * .05,
                  ),
                  Expanded(
                      child: CustomButtonA(
                          textColor: positiveButtonColor ??
                              Theme.of(context).colorScheme.primary,
                          buttonText: positiveButtonText,
                          onPress: () async {
                            await positiveButtonOnTap();
                          }))
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenWidth! * .035),
          ],
        ),
      ),
    );
  }
}
