import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address/add_edit_address_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';

class AddressTile extends StatelessWidget {
  const AddressTile(
      {Key? key,
      required this.isDefault,
      required this.data,
      required this.index})
      : super(key: key);

  final bool isDefault;
  final UserAddressObject data;
  final int index;

  final double textSize = 14.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Stack(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * .02),
                Text(
                  "Name: ${data.name}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                Text(
                  "Phone: ${data.phone}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                Text(
                  "Email: ${data.email}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * .02),
                Text(
                  "${data.addressLine1}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                Text(
                  "${data.addressLine2}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                Text(
                  "${data.city}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                Text(
                  "${data.state}, ${data.pinCode}",
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * .015),
                Consumer<UserAddressesProvider>(
                  builder: (context, addressprovider, _) =>
                      Consumer<UserProvider>(
                    builder: (context, currentUser, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomButtonA(
                            buttonText: "Edit",
                            textColor: Theme.of(context).colorScheme.primary,
                            onPress: () async {
                              NavigatorService.push(context,
                                  page: AddEditAddressScreen(
                                      index: index, addressData: data));
                            },
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenHeight! * .015),
                        Flexible(
                          child: CustomButtonA(
                            buttonText: "Remove",
                            textColor: Theme.of(context).colorScheme.error,
                            onPress: () async {
                              await addressprovider.removeAddressData(context,
                                  addressData: data,
                                  currentUser: currentUser.getCurrentUser!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (isDefault == true)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.screenWidth! * .015),
                    child: Icon(
                      FlutterRemix.check_fill,
                      color: Theme.of(context).colorScheme.background,
                      size: SizeConfig.screenWidth! * .06,
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
