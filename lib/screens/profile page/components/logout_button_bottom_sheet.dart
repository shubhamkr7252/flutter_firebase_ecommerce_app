import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';

import '../../../provider/user_provider.dart';
import '../../../theme/size.dart';
import '../../../widgets/custom_bottom_sheet_drag_handle.dart';

class LogoutConfirmationBottomSheet extends StatelessWidget {
  const LogoutConfirmationBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => WillPopScope(
        onWillPop: () async {
          return !userprovider.isLoading;
        },
        child: Padding(
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
                const CustomBottomSheetDragHandleWithTitle(
                  title: "Logout",
                ),
                SizedBox(height: SizeConfig.screenWidth! * .05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: Text(
                    "Logging out will clear all your data from this device and you will be redirected to login screen.",
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * .0335,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                              buttonText: "Cancel",
                              onPress: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(
                        width: SizeConfig.screenWidth! * .05,
                      ),
                      Expanded(
                          child: CustomElevatedButton(
                              bgColor: Theme.of(context).colorScheme.error,
                              buttonText: "Logout",
                              onPress: () async {
                                await userprovider.userLogout(context);
                              }))
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .035),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
