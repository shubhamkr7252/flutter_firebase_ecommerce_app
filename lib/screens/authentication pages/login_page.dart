import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication%20pages/registration_page.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/form_validart.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<FormState> _formKey;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool _hidePassword = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight!,
              width: SizeConfig.screenWidth!,
              color: Theme.of(context).colorScheme.primary,
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/shopping_pattern.jpg",
                width: SizeConfig.screenWidth!,
                height: SizeConfig.screenWidth! * 1.175,
                fit: BoxFit.cover,
              ),
            )),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(SizeConfig.screenHeight! * .01),
                          topRight:
                              Radius.circular(SizeConfig.screenHeight! * .01))),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth! * .075),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: SizeConfig.screenHeight! * .035),
                        Text(
                          "Welcome !",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.screenWidth! * .075),
                        ),
                        SizedBox(height: SizeConfig.screenHeight! * .005),
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextInput(
                                    controller: _emailController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please enter an email address.";
                                      }
                                      if (!isEmail(value.trim())) {
                                        return "Please enter a valid email address.";
                                      }
                                      return null;
                                    },
                                    hintTxt: "Email",
                                    inputAction: TextInputAction.next),
                                CustomTextInput(
                                    controller: _passwordController,
                                    suffixIcon: IconButton(
                                        color: _hidePassword
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        icon: _hidePassword
                                            ? const Icon(FlutterRemix.eye_fill)
                                            : const Icon(
                                                FlutterRemix.eye_off_fill),
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        }),
                                    obscureText: _hidePassword,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please input a password.";
                                      } else if (value.length < 6) {
                                        return "Password length should be more than 6 characters.";
                                      }
                                      return null;
                                    },
                                    hintTxt: "Password",
                                    inputAction: TextInputAction.done),
                                SizedBox(height: SizeConfig.screenWidth! * .05),
                                Consumer<UserProvider>(
                                  builder: (context, userprovider, _) =>
                                      CustomElevatedButton(
                                          buttonText: "Login",
                                          onPress: () async {
                                            FocusScope.of(context).unfocus();
                                            if (FormValidator.validate(
                                                key: _formKey)) {
                                              await userprovider.login(context,
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim());
                                            }
                                          }),
                                ),
                                SizedBox(height: SizeConfig.screenWidth! * .05),
                                Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: "Don't have an account? "),
                                      TextSpan(
                                        text: "Register",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            NavigatorService.push(context,
                                                page: const RegistrationPage());
                                          },
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight! * .035),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
