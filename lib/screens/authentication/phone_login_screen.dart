import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/utils/countdown_timer.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/external%20modified%20packages/country_calling_code_picker-2.0.1/lib/functions.dart';
import 'package:flutter_firebase_ecommerce_app/external%20modified%20packages/country_calling_code_picker-2.0.1/lib/country.dart';
import '../../service/firebase_auth_service.dart';
import '../../utils/form_validart.dart';
import '../../widgets/custom loader/custom_loader.dart';
import '../../widgets/custom_text_input.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _phoneController;

  late ValueNotifier<bool> _isLoading;
  late ValueNotifier<int> _timeoutLeft;
  late ValueNotifier<String> _previousPhoneNumber;
  late ValueNotifier<String> _verificationCode;
  late ValueNotifier<String> _countryCode;

  late int _timeout;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _phoneController = TextEditingController();

    _isLoading = ValueNotifier<bool>(false);
    _timeoutLeft = ValueNotifier<int>(0);
    _previousPhoneNumber = ValueNotifier<String>("");
    _verificationCode = ValueNotifier<String>("");
    _countryCode = ValueNotifier<String>("");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Country country = await getDefaultCountry(context);
      _countryCode.value = country.callingCode;
    });

    ///define timeout in seconds for the whole login process
    _timeout = 60;

    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _isLoading.dispose();
    _verificationCode.dispose();
    _previousPhoneNumber.dispose();
    _countryCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: SizeConfig.screenHeight! * .175,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Brightness.light
                  : Brightness.dark,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              FlutterRemix.arrow_left_fill,
              size: SizeConfig.screenWidth! * .06,
              color: Theme.of(context).colorScheme.background,
            )),
        title: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          ),
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .02),
          child: Image.asset(
            "assets/logo_outline.png",
            width: SizeConfig.screenHeight! * .05,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight! * .015),
                Text(
                  "Log in or sign up",
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth! * .0375,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .05),
                ValueListenableBuilder<String>(
                  valueListenable: _countryCode,
                  builder: (context, countrycode, child) => CustomTextInput(
                      hintTxt: "Phone Number",
                      hideTitle: true,
                      autoFocus: true,
                      isNumberInput: true,
                      isSpaceDenied: true,
                      maxLength: countrycode == "+91" ? 10 : null,
                      controller: _phoneController,
                      prefixIcon: InkWell(
                        onTap: () async {
                          Country? _country =
                              await showCountryPickerSheet(context);

                          if (_country != null) {
                            _countryCode.value = _country.callingCode;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth! * .03,
                            vertical: SizeConfig.screenWidth! * .015,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight! * .01),
                          ),
                          child: Text(
                            countrycode,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: SizeConfig.screenWidth! * .0375),
                          ),
                        ),
                      ),
                      inputAction: TextInputAction.done,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter a phone number.";
                        }
                        if (value.trim().length != 10) {
                          return "Please enter a valid phone number.";
                        }
                        return null;
                      }),
                ),
                SizedBox(height: SizeConfig.screenWidth! * .05),
                Consumer<UserProvider>(
                  builder: (context, userprovider, _) => Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.screenWidth!)),
                    height: SizeConfig.screenWidth! * .135,
                    width: SizeConfig.screenWidth!,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isloading, child) =>
                          ValueListenableBuilder<int>(
                        valueListenable: _timeoutLeft,
                        builder: (context, timeoutleft, child) =>
                            ValueListenableBuilder<String>(
                          valueListenable: _previousPhoneNumber,
                          builder: (context, previousphonenumber, child) =>
                              ValueListenableBuilder<String>(
                            valueListenable: _verificationCode,
                            builder: (context, verCode, child) =>
                                ValueListenableBuilder<String>(
                              valueListenable: _countryCode,
                              builder: (context, countrycode, child) =>
                                  OutlinedButton(
                                onPressed: () async {
                                  if (FormValidator.validate(key: _formKey)) {
                                    FocusScope.of(context).unfocus();
                                    if (timeoutleft != 0 &&
                                        previousphonenumber !=
                                            countrycode +
                                                _phoneController.text) {
                                      return CustomSnackbar.showSnackbar(
                                          context,
                                          title:
                                              "You can request a new OTP in ${_timeoutLeft.value} seconds",
                                          type: 2);
                                    } else if (timeoutleft != 0 &&
                                        previousphonenumber ==
                                            countrycode +
                                                _phoneController.text) {
                                      return showModalBottomSheet(
                                        context: context,
                                        isDismissible: false,
                                        enableDrag: false,
                                        elevation: 0,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            OTPVerificationScreen(
                                          phoneNumber: _phoneController.text,
                                          countryCode: countrycode,
                                          verificationCode: verCode,
                                          timeout: timeoutleft,
                                        ),
                                      );
                                    }
                                    _isLoading.value = true;

                                    await FirebaseAuthService.requestOTP(
                                      context,
                                      phoneNumber:
                                          countrycode + _phoneController.text,
                                      timeout: Duration(seconds: _timeout),
                                      onVerificationRecieved:
                                          (String verificationCode) async {
                                        _verificationCode.value =
                                            verificationCode;
                                      },
                                      afterVerificationRecievedCallback:
                                          () async {
                                        _previousPhoneNumber.value =
                                            countrycode + _phoneController.text;

                                        _isLoading.value = false;

                                        _timeoutLeft.value = _timeout;
                                        CountdownTimer.startTimer(
                                            time: _timeoutLeft.value,
                                            onTimeChanged: (int time) {
                                              _timeoutLeft.value = time;
                                            });

                                        showModalBottomSheet(
                                          context: context,
                                          isDismissible: false,
                                          enableDrag: false,
                                          elevation: 0,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              OTPVerificationScreen(
                                            phoneNumber: _phoneController.text,
                                            countryCode: countrycode,
                                            verificationCode:
                                                _verificationCode.value,
                                            timeout: _timeout,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                    width: 2.25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      (Theme.of(context).colorScheme.primary)
                                          .withOpacity(0.075)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.screenWidth!),
                                    ),
                                  ),
                                ),
                                child: isloading == true
                                    ? CustomLoader(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: SizeConfig.screenWidth! * .06)
                                    : Text("Continue",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
