import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/firebase_auth_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/countdown_timer.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom loader/custom_loader.dart';
import '../../widgets/custom_bottom_sheet_close_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
    required this.timeout,
    required this.verificationCode,
  }) : super(key: key);

  final String phoneNumber;
  final String countryCode;
  final String verificationCode;
  final int timeout;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
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
                      widget.countryCode + " " + widget.phoneNumber,
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
                                              "Please wait until timeout to resend code.");
                                    }

                                    _isOTPResending.value = true;
                                    await FirebaseAuthService.requestOTP(
                                      context,
                                      timeout: const Duration(seconds: 60),
                                      phoneNumber: widget.countryCode +
                                          widget.phoneNumber,
                                      onVerificationRecieved: (String value) {
                                        _verificationCode.value = value;
                                      },
                                      afterVerificationRecievedCallback:
                                          () async {
                                        _isOTPResending.value = false;

                                        _timeoutTimer.value = widget.timeout;
                                        CountdownTimer.startTimer(
                                            time: _timeoutTimer.value,
                                            onTimeChanged: (int time) {
                                              _timeoutTimer.value = time;
                                            });

                                        CustomSnackbar.showSnackbar(context,
                                            title: "OTP sent successfully",
                                            position: ToastPosition.top,
                                            type: 1);
                                      },
                                    );
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

                                    Map<String, dynamic>? _phonAuthData =
                                        await FirebaseAuthService.phoneLogin(
                                            context,
                                            verificationId: verId.isEmpty
                                                ? widget.verificationCode
                                                : verId,
                                            smsCode: _controller.text);

                                    await userprovider.phoneLogin(context,
                                        userIdAndToken: _phonAuthData);
                                  }),
                            ),
                          ),
                        ),
                      ],
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
