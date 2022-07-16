import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class FirebaseAuthService {
  static Future<Map<String, dynamic>?> login(BuildContext context,
      {required String email, required String password}) async {
    Map<String, dynamic> userData = {};

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final OSDeviceState? _oneSignalStatus =
          await OneSignal.shared.getDeviceState();

      userData["uid"] = _firebaseAuth.currentUser!.uid;
      userData["token"] = _oneSignalStatus!.userId!;

      return userData;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackbar.showSnackbar(context,
            title: "Invalid user",
            description: "Please provide a valid email address.",
            type: 2);
      } else if (e.code == 'wrong-password') {
        CustomSnackbar.showSnackbar(context,
            title: "Invalid credentials",
            description: "Please provider correct password.",
            type: 2);
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  static Future<Map<String, dynamic>?> createUser(BuildContext context,
      {required String email, required String password}) async {
    Map<String, dynamic> userData = {};

    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    OSDeviceState? _oneSignalStatus = await OneSignal.shared.getDeviceState();

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      userData["uid"] = _firebaseAuth.currentUser!.uid;
      userData["token"] = _oneSignalStatus!.userId!;

      return userData;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomSnackbar.showSnackbar(context,
            title: "The password provided is too weak",
            description: "Please use a strong password.",
            type: 2);
      } else if (e.code == 'email-already-in-use') {
        CustomSnackbar.showSnackbar(context,
            title: "The account already exists for that email",
            description: "Please use a differnent email address.",
            type: 2);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
