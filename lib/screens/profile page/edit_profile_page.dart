import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/utils/form_validart.dart';
import 'package:flutter_firebase_ecommerce_app/extension/string_casing_extension.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_text_input.dart';
import '../../theme/size.dart';
import 'components/edit_profile_image_selection_bottom_sheet.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  late GlobalKey<FormState> _formKey;

  late UserProvider _userProvider;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _userProvider = Provider.of(context, listen: false);
    _firstNameController.text = _userProvider.getCurrentUser!.firstName!;
    _lastNameController.text = _userProvider.getCurrentUser!.lastName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userprovider, _) => CustomScaffold(
        title: "Edit Profile",
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                                        return "Fist Name cannot be empty";
                                      }
                                      return null;
                                    },
                                    capitalization: TextCapitalization.words,
                                    formatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'\s')),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.screenHeight! * .005),
                                  CustomTextInput(
                                      controller: _lastNameController,
                                      hintTxt: "Last Name",
                                      validator: (String? value) {
                                        return null;
                                      },
                                      capitalization: TextCapitalization.words),
                                  SizedBox(
                                      height: SizeConfig.screenWidth! * .05),
                                  Consumer<UserProvider>(
                                    builder: (context, userprovider, _) =>
                                        CustomElevatedButton(
                                            buttonText: "Save",
                                            onPress: () async {
                                              FocusScope.of(context).unfocus();
                                              if (FormValidator.validate(
                                                  key: _formKey)) {
                                                await userprovider
                                                    .updateUserNameDataAndImage(
                                                        context,
                                                        firstName:
                                                            _firstNameController
                                                                .text
                                                                .trim(),
                                                        lastName:
                                                            _lastNameController
                                                                .text
                                                                .trim()
                                                                .toTitleCase());

                                                Future.delayed(const Duration(
                                                        seconds: 1))
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                });
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
                        builder: (context, userprovider, _) =>
                            CustomElevatedButton(
                                buttonText: "Delete Account",
                                bgColor: Theme.of(context).colorScheme.error,
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                }),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth! * .025),
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