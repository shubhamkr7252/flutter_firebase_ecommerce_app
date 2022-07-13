import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address/my_address_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20order/my_order.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/edit_profile_screen.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication/login_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/components/custom_confirmation_bottom_sheet.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

import '../../widgets/custom_button_a.dart';
import '../wishlist/wishlist_screen.dart';
import 'components/profile_image.dart';
import 'components/profile_options_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Map<String, dynamic>> _profileItems;

  @override
  void initState() {
    _profileItems = [
      {
        "icon": FlutterRemix.shopping_bag_3_fill,
        "iconOutline": FlutterRemix.shopping_bag_3_line,
        "title": "My Orders",
      },
      {
        "icon": FlutterRemix.heart_3_fill,
        "iconOutline": FlutterRemix.heart_3_line,
        "title": "My Wishlist",
      },
      {
        "icon": FlutterRemix.map_pin_2_fill,
        "iconOutline": FlutterRemix.map_pin_2_line,
        "title": "My Addresses",
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => Padding(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight! * .015,
                    vertical: SizeConfig.screenHeight! * .025),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          ProfilePic(
                            size: SizeConfig.screenWidth! * .15,
                          ),
                          SizedBox(width: SizeConfig.screenWidth! * .05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Welcome",
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth! * .04,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )),
                                const SizedBox(height: .05),
                                SizedBox(
                                  width: SizeConfig.screenWidth! * .5,
                                  child: Text(
                                      userprovider.getCurrentUser != null
                                          ? userprovider
                                                  .getCurrentUser!.firstName! +
                                              (userprovider.getCurrentUser!
                                                          .lastName !=
                                                      null
                                                  ? " " +
                                                      userprovider
                                                          .getCurrentUser!
                                                          .lastName!
                                                  : "")
                                          : "User",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          fontSize:
                                              SizeConfig.screenWidth! * .05)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SizeConfig.screenWidth! * .015),
                    InkResponse(
                      onTap: () {
                        NavigatorService.push(context,
                            page: const EditProfileScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.background),
                        padding:
                            EdgeInsets.all(SizeConfig.screenHeight! * .015),
                        child: Icon(FlutterRemix.edit_2_fill,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            Column(
                children: List.generate(_profileItems.length, (index) {
              return Padding(
                padding: index == 0 || index == _profileItems.length
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: SizeConfig.screenHeight! * .015),
                child: ProfileOptionsTile(
                  icon: _profileItems[index]["icon"],
                  title: _profileItems[index]["title"],
                  iconOutline: _profileItems[index]["iconOutline"],
                  onTap: () {
                    if (index == 0) {
                      NavigatorService.push(context,
                          page: MyOrderScreen(
                              userId: userprovider.getCurrentUser!.id!));
                    }
                    if (index == 1) {
                      NavigatorService.push(context,
                          page: WishlistScreen(
                              userId: userprovider.getCurrentUser!.id!));
                    }
                    if (index == 2) {
                      NavigatorService.push(context,
                          page: MyAddressScreen(
                            userId: userprovider.getCurrentUser!.id!,
                          ));
                    }
                  },
                ),
              );
            })),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            Consumer<UploadUserProfileImageProvider>(
              builder: (context, uploaduserprofileimageprovider, _) =>
                  CustomButtonA(
                      buttonText: userprovider.getCurrentUser != null
                          ? "Logout"
                          : "Login",
                      onPress: () {
                        if (userprovider.getCurrentUser != null) {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => CustomConfirmationBottomSheet(
                                    title: "Logout",
                                    description:
                                        "Logging out will clear all your data from this device and you will be redirected to login screen.",
                                    positiveButtonOnTap: () async {
                                      await userprovider.userLogout(context);
                                    },
                                    positiveButtonText: 'Logout',
                                  ));
                        } else {
                          NavigatorService.push(context,
                              page: const LoginScreen());
                        }
                      }),
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        showLicensePage(
                            context: context,
                            applicationName: "Flutter Firebase Ecommerce App",
                            applicationVersion: "1.0",
                            applicationLegalese: "Copyright Here",
                            applicationIcon: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.screenHeight! * .015),
                              child: Image.asset(
                                "assets/logo.png",
                                width: SizeConfig.screenWidth! * .1,
                              ),
                            ));
                      },
                      child: const Text("About"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
