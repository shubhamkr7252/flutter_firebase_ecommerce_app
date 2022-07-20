import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/components/custom_confirmation_bottom_sheet.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/utils/form_validart.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_text_input.dart';
import 'package:validators/validators.dart';
import '../../theme/size.dart';
import '../../widgets/custom_snackbar.dart';
import 'components/edit_profile_image_selection_bottom_sheet.dart';
import 'email_otp_verification_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  late GlobalKey<FormState> _formKey;

  late UserProvider _userProvider;

  late EmailAuth _emailAuth;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _userProvider = Provider.of(context, listen: false);
    _firstNameController.text = _userProvider.getCurrentUser!.firstName!;
    _lastNameController.text = _userProvider.getCurrentUser!.lastName!;
    _emailController.text = _userProvider.getCurrentUser!.email!;

    _emailAuth = EmailAuth(sessionName: "Fly Buy");

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => CustomScaffold(
        resizeToAvoidBottomInset: true,
        title: "Edit Profile",
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight! * .035),
                            child: Align(
                              alignment: Alignment.center,
                              child: Consumer<UploadUserProfileImageProvider>(
                                builder: (context,
                                        uploaduserprofileimageprovider, _) =>
                                    Stack(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenWidth! * .3,
                                      width: SizeConfig.screenWidth! * .3,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: uploaduserprofileimageprovider
                                                        .getImageFile !=
                                                    null
                                                ? FileImage(
                                                    uploaduserprofileimageprovider
                                                        .getImageFile!)
                                                : (userprovider.getCurrentUser!
                                                            .image !=
                                                        null
                                                    ? CachedNetworkImageProvider(
                                                        userprovider
                                                            .getCurrentUser!
                                                            .image!)
                                                    : const AssetImage(
                                                            "assets/temporary_user_picture.png")
                                                        as ImageProvider),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          highlightColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5),
                                          splashColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.screenWidth!),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  const EditProfileImageSelectionBottomSheet(),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  SizeConfig.screenWidth! *
                                                      .0075),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(
                                                    SizeConfig.screenWidth! *
                                                        .0225),
                                                child: Icon(
                                                  FlutterRemix.image_edit_fill,
                                                  size:
                                                      SizeConfig.screenWidth! *
                                                          .055,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
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
                          SizedBox(height: SizeConfig.screenWidth! * .025),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenHeight! * .015),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextInput(
                                    controller: _firstNameController,
                                    hintTxt: "First Name",
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your first name";
                                      }
                                      return null;
                                    },
                                    capitalization: TextCapitalization.words,
                                    isSpaceDenied: true,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  CustomTextInput(
                                      controller: _lastNameController,
                                      hintTxt: "Last Name",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your first name";
                                        }
                                        return null;
                                      },
                                      capitalization: TextCapitalization.words),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  CustomTextInput(
                                    controller: _emailController,
                                    hintTxt: "Email",
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your email";
                                      }
                                      if (value.isNotEmpty && !isEmail(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    capitalization: TextCapitalization.words,
                                    isSpaceDenied: true,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenWidth! * .05),
                                  Consumer<UserProvider>(
                                    builder: (context, userprovider, _) =>
                                        CustomButtonA(
                                            buttonText: "Save",
                                            onPress: () async {
                                              FocusScope.of(context).unfocus();
                                              if (!FormValidator.validate(
                                                  key: _formKey)) {
                                                return;
                                              }

                                              if (userprovider
                                                      .getCurrentUser!.email!
                                                      .toLowerCase() ==
                                                  _emailController.text
                                                      .toLowerCase()) {
                                                await userprovider
                                                    .updateUserData(
                                                  context,
                                                  firstName:
                                                      _firstNameController.text,
                                                  lastName:
                                                      _lastNameController.text,
                                                  email: _emailController.text,
                                                );

                                                CustomSnackbar.showSnackbar(
                                                    context,
                                                    title:
                                                        "Profile updated successfully",
                                                    type: 1);

                                                Navigator.of(context).pop();
                                              } else {
                                                bool _result =
                                                    await _emailAuth.sendOtp(
                                                        recipientMail:
                                                            _emailController
                                                                .text
                                                                .trim(),
                                                        otpLength: 5);

                                                if (_result) {
                                                  return showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      isDismissible: false,
                                                      enableDrag: false,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          EmailOTPVerificationScreen(
                                                            timeout: 60,
                                                            email:
                                                                _emailController
                                                                    .text
                                                                    .trim(),
                                                            emailAuthService:
                                                                _emailAuth,
                                                            firstName:
                                                                _firstNameController
                                                                    .text,
                                                            lastName:
                                                                _lastNameController
                                                                    .text
                                                                    .trim(),
                                                          ));
                                                }
                                                return CustomSnackbar
                                                    .showSnackbar(context,
                                                        title:
                                                            "Some error occurred",
                                                        type: 2);
                                              }
                                            }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenWidth! * .025),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenHeight! * .015),
                      child: Consumer<UserProvider>(
                        builder: (context, userprovider, _) => CustomButtonA(
                            buttonText: "Delete Account",
                            textColor: Theme.of(context).colorScheme.error,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                              showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  elevation: 0,
                                  builder: (context) =>
                                      CustomConfirmationBottomSheet(
                                          title: "Delete Account?",
                                          description:
                                              "Are you sure you want to delete your account? Deleting account will remove all your data and you will have to create a new account to use the app again.",
                                          buttonOnTap: () async {
                                            await userprovider
                                                .deleteAccount(context);
                                          },
                                          buttonText: "Save"));
                            }),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
