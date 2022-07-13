import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20main%20navigation/home_main_navigation.dart';
import 'package:flutter_firebase_ecommerce_app/service/hive_boxes.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import '../provider/user_provider.dart';

class AuthService {
  static Future<void> init(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      UserProvider _provider = Provider.of(context, listen: false);
      await _provider.init(userId: currentUser.uid);

      HiveBoxes.registerAdapters();

      Future.delayed(const Duration(seconds: 0)).then((value) {
        NavigatorService.pushReplaceUntil(context,
            page: const HomeMainNavigation());
      });
    } else {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        NavigatorService.pushReplaceUntil(context, page: const LoginScreen());
      });
    }
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    NavigatorService.pushReplaceUntil(context, page: const LoginScreen());
  }
}
