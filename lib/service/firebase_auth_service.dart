import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication/welcome_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:oktoast/oktoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final OneSignal _oneSignalStatus = OneSignal.shared;

  static Future<void> requestOTP(
    BuildContext context, {
    required String phoneNumber,
    required Function(String) onVerificationRecieved,
    required Duration timeout,
    required AsyncCallback afterVerificationRecievedCallback,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        CustomSnackbar.showSnackbar(context, title: e.message!, type: 2);
      },
      codeSent: (String verificationId, int? resendToken) async {
        await onVerificationRecieved(verificationId);
        await afterVerificationRecievedCallback();

        log(verificationId);
      },
      timeout: timeout,
      codeAutoRetrievalTimeout: (String verificationId) {
        onVerificationRecieved(verificationId);

        log("timed out");
      },
    );
  }

  static Future<Map<String, dynamic>?> phoneLogin(BuildContext context,
      {required String verificationId, required String smsCode}) async {
    OSDeviceState? _token = await _oneSignalStatus.getDeviceState();
    try {
      UserCredential _userCreds =
          await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        ),
      );

      if (_userCreds.user != null) {
        Map<String, dynamic> userData = {};
        userData["uid"] = _userCreds.user!.uid;
        userData["phone"] = _userCreds.user!.phoneNumber;
        userData["token"] = _token!.userId!;
        return userData;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        CustomSnackbar.showSnackbar(
          context,
          title: "Invalid OTP",
          type: 2,
          position: ToastPosition.top,
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<void> deleteAccount(BuildContext context) async {
    await _firebaseAuth.currentUser!.delete();

    Future.delayed(const Duration(seconds: 0)).then((value) {
      NavigatorService.pushReplaceUntil(context, page: const WelcomeScreen());
    });
  }
}
