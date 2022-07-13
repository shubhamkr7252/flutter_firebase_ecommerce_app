import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userprovider, _) {
      return Container(
        height: size ?? SizeConfig.screenWidth! * .35,
        width: size ?? SizeConfig.screenWidth! * .35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: userprovider.getCurrentUser != null
                  ? userprovider.getCurrentUser!.image != null
                      ? CachedNetworkImageProvider(
                          userprovider.getCurrentUser!.image!,
                        )
                      : const AssetImage("assets/temporary_user_picture.png")
                          as ImageProvider
                  : const AssetImage("assets/temporary_user_picture.png"),
              fit: BoxFit.cover),
        ),
      );
    });
  }

  String getNameInitials(String nameData) {
    List<String> data = nameData.split(" ");
    if (data.length > 1) {
      return data[0][0] + data[1][0];
    } else {
      return nameData.substring(0, 2);
    }
  }
}
