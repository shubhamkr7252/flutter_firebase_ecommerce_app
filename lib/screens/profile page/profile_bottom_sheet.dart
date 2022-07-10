import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication%20pages/login_page.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address%20page/my_address.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20order%20page/my_order.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile%20page/components/logout_button_bottom_sheet.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile%20page/edit_profile_page.dart';
import 'package:flutter_firebase_ecommerce_app/screens/wishlist%20page/wishlist_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';

import 'components/profile_image.dart';
import 'components/profile_options_tile.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({Key? key}) : super(key: key);

  @override
  _ProfileBottomSheetState createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  late List<Map<String, dynamic>> _profileItems;

  @override
  void initState() {
    _profileItems = [
      {
        "icon": FlutterRemix.shopping_bag_3_fill,
        "color": Colors.blue,
        "title": "My Orders",
      },
      {
        "icon": FlutterRemix.heart_3_fill,
        "color": Colors.red,
        "title": "My Wishlist",
      },
      {
        "icon": FlutterRemix.map_pin_2_fill,
        "color": Colors.green,
        "title": "My Addresses",
      },
      {
        "icon": FlutterRemix.logout_box_fill,
        "color": Colors.purple,
        "title": "logout",
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => Padding(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .015)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const CustomBottomSheetDragHandleWithTitle(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight! * .015),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: SizeConfig.screenWidth! * .05),
                    Row(
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
                                      fontFamily: "Poppins")),
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
                                                    userprovider.getCurrentUser!
                                                        .lastName!
                                                : "")
                                        : "User",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Poppins",
                                        fontSize:
                                            SizeConfig.screenWidth! * .05)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (userprovider.getCurrentUser != null)
                SizedBox(height: SizeConfig.screenWidth! * .065),
              if (userprovider.getCurrentUser != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ProfileOptionsTile(
                                icon: _profileItems[0]["icon"],
                                title: _profileItems[0]["title"],
                                bgColor: _profileItems[0]["color"],
                                onTap: () {
                                  NavigatorService.push(context,
                                      page: MyOrder(
                                          userId: userprovider
                                              .getCurrentUser!.id!));
                                }),
                          ),
                          SizedBox(width: SizeConfig.screenHeight! * .015),
                          Expanded(
                            child: ProfileOptionsTile(
                                icon: _profileItems[1]["icon"],
                                title: _profileItems[1]["title"],
                                bgColor: _profileItems[1]["color"],
                                onTap: () {
                                  NavigatorService.push(context,
                                      page: WishlistScreen(
                                          userId: userprovider
                                              .getCurrentUser!.id!));
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                      Row(
                        children: [
                          Expanded(
                            child: ProfileOptionsTile(
                                icon: _profileItems[2]["icon"],
                                title: _profileItems[2]["title"],
                                bgColor: _profileItems[2]["color"],
                                onTap: () {
                                  NavigatorService.push(context,
                                      page: const MyAddress());
                                }),
                          ),
                          SizedBox(width: SizeConfig.screenHeight! * .015),
                          Expanded(
                            child: ProfileOptionsTile(
                                icon: _profileItems[3]["icon"],
                                title: _profileItems[3]["title"],
                                bgColor: _profileItems[3]["color"],
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) =>
                                          const LogoutConfirmationBottomSheet());
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(height: SizeConfig.screenWidth! * .05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight! * .015),
                child: Consumer<UploadUserProfileImageProvider>(
                  builder: (context, uploaduserprofileimageprovider, _) =>
                      CustomElevatedButton(
                          buttonText: userprovider.getCurrentUser != null
                              ? "Edit Profile"
                              : "Login",
                          onPress: () {
                            if (userprovider.getCurrentUser != null) {
                              NavigatorService.push(context,
                                  page: const EditProfilePage());
                            } else {
                              NavigatorService.push(context,
                                  page: const LoginPage());
                            }
                          }),
                ),
              ),
              SizedBox(height: SizeConfig.screenWidth! * .025),
            ],
          ),
        ),
      ),
    );
  }
}
