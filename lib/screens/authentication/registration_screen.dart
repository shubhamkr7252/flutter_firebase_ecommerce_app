import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_data.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/form_validart.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_nested_scroll_view_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_text_input.dart';
import 'package:validators/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late GlobalKey<FormState> _formKey;
  late bool _hidePassword;
  late bool _hideCnfPassword;

  late FocusNode _cnfPasswordFocus;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cnfPasswordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    _hidePassword = true;
    _hideCnfPassword = true;

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cnfPasswordController = TextEditingController();

    _cnfPasswordFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cnfPasswordController.dispose();

    _cnfPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomNestedScrollViewScaffold(
      title: "Create A New Account",
      hideAppbarActions: true,
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .015),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextInput(
                        controller: _nameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter your name.";
                          }
                          if (value.length < 2) {
                            return "Name should be more than 2 characters";
                          }
                          return null;
                        },
                        capitalization: TextCapitalization.words,
                        hintTxt: "Name",
                        inputAction: TextInputAction.next),
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please input a password.";
                        } else if (value.length < 6) {
                          return "Password length should be more than 6 characters.";
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                          color: _hidePassword
                              ? Colors.grey
                              : Theme.of(context).colorScheme.secondary,
                          icon: _hidePassword
                              ? const Icon(FlutterRemix.eye_fill)
                              : const Icon(FlutterRemix.eye_off_fill),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          }),
                      obscureText: _hidePassword,
                      hintTxt: "Password",
                      onSave: () {
                        FocusScope.of(context).requestFocus(_cnfPasswordFocus);
                      },
                    ),
                    CustomTextInput(
                        controller: _cnfPasswordController,
                        node: _cnfPasswordFocus,
                        suffixIcon: IconButton(
                            color: _hideCnfPassword
                                ? Colors.grey
                                : Theme.of(context).colorScheme.secondary,
                            icon: _hideCnfPassword
                                ? const Icon(FlutterRemix.eye_fill)
                                : const Icon(FlutterRemix.eye_off_fill),
                            onPressed: () {
                              setState(() {
                                _hideCnfPassword = !_hideCnfPassword;
                              });
                            }),
                        obscureText: _hideCnfPassword,
                        validator: (String? value) {
                          if (value != _passwordController.text ||
                              value!.isEmpty) {
                            return "Passwords do not match.";
                          }
                          return null;
                        },
                        hintTxt: "Confirm password",
                        inputAction: TextInputAction.done),
                    SizedBox(
                      height: SizeConfig.screenWidth! * 0.05,
                    ),
                    Consumer<UserProvider>(
                      builder: (context, userprovider, _) => CustomButtonA(
                          buttonText: "Register",
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (FormValidator.validate(key: _formKey)) {
                              await userprovider.addCustomer(
                                context,
                                password: _passwordController.text.trim(),
                                userData: UserData.fromJson({
                                  "id": "",
                                  "email": _emailController.text.trim(),
                                  "firstName":
                                      _nameController.text.split(" ").first,
                                  "lastName":
                                      getLastName(_nameController.text.trim()),
                                }),
                              );
                            }
                          }),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .05),
                  ]),
            ),
          )),
    );
  }

  String getLastName(String name) {
    List<String> newName = name.split(" ");

    if (newName.length > 1) {
      newName.removeAt(0);
      return newName.toString().replaceAll("[", "").replaceAll("]", "");
    }
    return "";
  }
}
