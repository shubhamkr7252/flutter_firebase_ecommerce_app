import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/extension/string_casing_extension.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication/phone_login_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Brightness.light
                  : Brightness.dark,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  ),
                  padding: EdgeInsets.all(SizeConfig.screenHeight! * .03),
                  child: Image.asset(
                    "assets/logo_outline.png",
                    color: Theme.of(context).colorScheme.primary,
                    width: SizeConfig.screenHeight! * .075,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: SizeConfig.screenWidth! * .035),
                    Text(
                      "The right address for shopping anyday".toTitleCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! * .075,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                    Text(
                      "It is not very easy to reach the best quality among all",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! * .0375,
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.75),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .035),
                  ],
                ),
                CustomButtonA(
                  buttonText: "Get Started",
                  textColor: Theme.of(context).colorScheme.background,
                  onPress: () async {
                    NavigatorService.push(context,
                        page: const PhoneLoginScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
