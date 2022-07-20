import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/countdown_timer.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom loader/custom_loader.dart';
import '../../widgets/custom_bottom_sheet_close_button.dart';

class EmailOTPVerificationScreen extends StatefulWidget {
  const EmailOTPVerificationScreen({
    Key? key,
    required this.timeout,
    required this.email,
    required this.emailAuthService,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  final String email;
  final String firstName;
  final String lastName;
  final EmailAuth emailAuthService;
  final int timeout;

  @override
  State<EmailOTPVerificationScreen> createState() =>
      _EmailOTPVerificationScreenState();
}

class _EmailOTPVerificationScreenState
    extends State<EmailOTPVerificationScreen> {
  late ValueNotifier<bool> _hasError;
  late ValueNotifier<String> _verificationCode;
  late ValueNotifier<int> _timeoutTimer;

  late ValueNotifier<bool> _isOTPResending;

  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _hasError = ValueNotifier<bool>(false);
    _isOTPResending = ValueNotifier<bool>(false);
    _verificationCode = ValueNotifier<String>("");
    _timeoutTimer = ValueNotifier<int>(widget.timeout);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CountdownTimer.startTimer(
          time: _timeoutTimer.value,
          onTimeChanged: (int time) {
            _timeoutTimer.value = time;
          });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hasError.dispose();
    _verificationCode.dispose();
    _isOTPResending.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomBottomSheetCloseButton(),
        Flexible(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.25),
                      blurRadius: 2.0,
                    ),
                  ],
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                ),
                padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                    Text(
                      "We have sent a verification code to",
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth! * .035,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth! * .045,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .05),
                    ValueListenableBuilder<bool>(
                      valueListenable: _hasError,
                      builder: (context, hasError, child) => PinCodeTextField(
                        pinBoxBorderWidth: 2.25,
                        pinBoxOuterPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth! * .02),
                        autofocus: true,
                        controller: _controller,
                        highlight: true,
                        focusNode: _focusNode,
                        pinBoxRadius: SizeConfig.screenHeight! * .01,
                        highlightColor: Theme.of(context).colorScheme.primary,
                        defaultBorderColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        hasTextBorderColor:
                            Theme.of(context).colorScheme.primary,
                        pinBoxColor: Theme.of(context).colorScheme.background,
                        errorBorderColor: Theme.of(context).colorScheme.error,
                        maxLength: 6,
                        hasError: hasError,
                        onTextChanged: (text) {
                          _hasError.value = false;
                        },
                        onDone: (value) {
                          _focusNode.requestFocus();
                        },
                        pinBoxWidth: SizeConfig.screenWidth! * .105,
                        pinBoxHeight: SizeConfig.screenWidth! * .15,
                        hasUnderline: true,
                        wrapAlignment: WrapAlignment.spaceEvenly,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle:
                            TextStyle(fontSize: SizeConfig.screenWidth! * .05),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.defaultNoTransition,
                        pinTextAnimatedSwitcherDuration:
                            const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .075),
                    Row(
                      children: [
                        Flexible(
                          child: ValueListenableBuilder(
                            valueListenable: _timeoutTimer,
                            builder: (context, value, child) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.screenWidth!)),
                              height: SizeConfig.screenWidth! * .135,
                              width: SizeConfig.screenWidth!,
                              child: ValueListenableBuilder(
                                valueListenable: _isOTPResending,
                                builder: (context, isotpresent, child) =>
                                    OutlinedButton(
                                  onPressed: () async {
                                    if (value != 0) {
                                      return CustomSnackbar.showSnackbar(
                                          context,
                                          title:
                                              "Please wait until timeout to resend code");
                                    }

                                    _isOTPResending.value = true;
                                    bool _result = await widget.emailAuthService
                                        .sendOtp(recipientMail: widget.email);

                                    if (_result) {
                                      CustomSnackbar.showSnackbar(context,
                                          title: "OTP sent successfully",
                                          type: 1);
                                    } else {
                                      return CustomSnackbar.showSnackbar(
                                          context,
                                          title: "Some error occurred",
                                          type: 2);
                                    }
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                      width: 2.25,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        (Theme.of(context).colorScheme.error)
                                            .withOpacity(0.075)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.screenWidth!),
                                      ),
                                    ),
                                  ),
                                  child: isotpresent == true
                                      ? CustomLoader(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          size: SizeConfig.screenWidth! * .06)
                                      : Text(
                                          "Resend" +
                                              (value != 0 ? " ($value)" : ""),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                SizeConfig.screenWidth! * .0325,
                                          )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth! * .03),
                        Consumer<UserProvider>(
                          builder: (context, userprovider, _) => Flexible(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _verificationCode,
                              builder: (context, verId, child) => CustomButtonA(
                                  buttonText: "Verify",
                                  onPress: () async {
                                    if (_controller.text.length != 6 ||
                                        _controller.text.isEmpty) {
                                      _hasError.value = true;
                                      return CustomSnackbar.showSnackbar(
                                        context,
                                        title: "Please enter a valid OTP",
                                        type: 2,
                                      );
                                    }

                                    bool _isEmailValidated =
                                        widget.emailAuthService.validateOtp(
                                            recipientMail: widget.email,
                                            userOtp: _controller.text);

                                    if (_isEmailValidated) {
                                      await userprovider.updateUserData(context,
                                          firstName: widget.firstName,
                                          lastName: widget.lastName,
                                          email: widget.email);

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();

                                      CustomSnackbar.showSnackbar(context,
                                          title: "Profile updated successfully",
                                          type: 1);
                                    } else {
                                      return CustomSnackbar.showSnackbar(
                                          context,
                                          title: "Invalid OTP",
                                          type: 2);
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .05),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.75),
                          fontSize: SizeConfig.screenWidth! * .0325,
                          fontStyle: FontStyle.italic,
                        ),
                        children: [
                          const TextSpan(text: "Please check your "),
                          TextSpan(
                            text: "Spam",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.75),
                            ),
                          ),
                          const TextSpan(text: " or "),
                          TextSpan(
                            text: "Junk",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.75),
                            ),
                          ),
                          const TextSpan(
                              text: " folder if you can't find the email"),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
