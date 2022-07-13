import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_snackbar.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_text_input.dart';

class AddEditAddressScreen extends StatefulWidget {
  const AddEditAddressScreen({Key? key, required this.index, this.addressData})
      : super(key: key);

  final int index;
  final UserAddressObject? addressData;

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _addressTitleController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinCodeController;

  late bool _isDefaultAddress;

  late ScrollController _scrollController;

  late ValueNotifier<bool> _isUserScrolling;

  @override
  void initState() {
    _addressTitleController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _pinCodeController = TextEditingController();

    if (widget.addressData != null) {
      _addressTitleController.text = widget.addressData!.title!;
      _nameController.text = widget.addressData!.name!;
      _phoneController.text = widget.addressData!.phone!;
      _emailController.text = widget.addressData!.email!;
      _addressLine1Controller.text = widget.addressData!.addressLine1!;
      _addressLine2Controller.text = widget.addressData!.addressLine2!;
      _cityController.text = widget.addressData!.city!;
      _stateController.text = widget.addressData!.state!;
      _pinCodeController.text = widget.addressData!.pinCode!;
    }

    _isUserScrolling = ValueNotifier<bool>(false);

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isUserScrolling.value == false) {
          _isUserScrolling.value = true;
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isUserScrolling.value == true) {
            _isUserScrolling.value = false;
          }
        }
      }
    });

    _isDefaultAddress = false;

    super.initState();
  }

  @override
  void dispose() {
    _addressTitleController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();

    _scrollController.dispose();
    _isUserScrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      title: widget.addressData == null ? "Add Address" : "Edit Address",
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: Consumer<UserAddressesProvider>(
              builder: (context, addressprovider, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.addressData == null ||
                      (addressprovider.getDefaultAddressData != null &&
                          addressprovider.getDefaultAddressData!.addressId !=
                              widget.addressData!.addressId))
                    AbsorbPointer(
                      absorbing: addressprovider.getDefaultAddressData == null
                          ? true
                          : false,
                      child: CustomCheckbox(
                          value: addressprovider.getDefaultAddressData != null
                              ? (widget.addressData != null &&
                                      addressprovider.getDefaultAddressData!
                                              .addressId ==
                                          widget.addressData!.addressId
                                  ? true
                                  : false)
                              : true,
                          onValueChanged: (value) {
                            _isDefaultAddress = value;
                          }),
                    ),
                  CustomTextInput(
                    controller: _addressTitleController,
                    hintTxt: "Address Title",
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Title cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Name",
                    controller: _nameController,
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Name cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Phone",
                    controller: _phoneController,
                    isNumberInput: true,
                    maxLength: 10,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Phone field cannot be empty.";
                      } else if (value.length > 10) {
                        return "Phone cannot be more than 6 digits.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Email",
                    controller: _emailController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Email field cannot be empty.";
                      } else if (!isEmail(value.trim())) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Address Line 1",
                    controller: _addressLine1Controller,
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Address field cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Address Line 2",
                    controller: _addressLine2Controller,
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Address field cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "City",
                    controller: _cityController,
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "City field cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "State",
                    controller: _stateController,
                    capitalization: TextCapitalization.words,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "State field cannot be empty.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                  CustomTextInput(
                    hintTxt: "Pin Code",
                    controller: _pinCodeController,
                    isNumberInput: true,
                    maxLength: 6,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Pin Code cannot be empty.";
                      } else if (value.length > 6) {
                        return "Pin code cannot be more than 6 digits.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * .015),
                ],
              ),
            ),
          ),
        ),
      ),
      fab: Consumer<UserProvider>(
        builder: (context, currentUser, _) => Consumer<UserAddressesProvider>(
          builder: (context, useraddressprovider, _) => ValueListenableBuilder(
            valueListenable: _isUserScrolling,
            builder: (context, value, child) => AnimatedSlide(
              offset: value == false
                  ? const Offset(0, 0)
                  : Offset(0, SizeConfig.screenWidth! * .0045),
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                onPressed: () async {
                  if (validataAndSave()) {
                    if (widget.addressData == null) {
                      Map<String, dynamic> newAddressData = {
                        "addressId": const Uuid()
                            .v5(Uuid.NAMESPACE_URL, widget.index.toString()),
                        "title": _addressTitleController.text.trim(),
                        "name": _nameController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "email": _emailController.text.trim(),
                        "addressLine1": _addressLine1Controller.text.trim(),
                        "addressLine2": _addressLine2Controller.text.trim(),
                        "city": _cityController.text.trim(),
                        "state": _stateController.text.trim(),
                        "pinCode": _pinCodeController.text.trim(),
                      };

                      await useraddressprovider.addAddressData(context,
                          data: newAddressData,
                          index: widget.index,
                          currentUser: currentUser.getCurrentUser!);

                      if (_isDefaultAddress == true) {
                        await useraddressprovider.modfiyDeafultAddressData(
                            context: context,
                            addressID: newAddressData["addressId"]);
                      }

                      CustomSnackbar.showSnackbar(context,
                          content: "Address added");
                    } else {
                      Map<String, dynamic> updatedAddressData = {
                        "addressId": widget.addressData!.addressId,
                        "title": _addressTitleController.text.trim(),
                        "name": _nameController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "email": _emailController.text.trim(),
                        "addressLine1": _addressLine1Controller.text.trim(),
                        "addressLine2": _addressLine2Controller.text.trim(),
                        "city": _cityController.text.trim(),
                        "state": _stateController.text.trim(),
                        "pinCode": _pinCodeController.text.trim(),
                      };

                      await useraddressprovider.updateAddressData(context,
                          oldAddressData: widget.addressData!.toJson(),
                          newAddressData: updatedAddressData,
                          currentUser: currentUser.getCurrentUser!);

                      if (_isDefaultAddress == true) {
                        await useraddressprovider.modfiyDeafultAddressData(
                            context: context,
                            addressID: widget.addressData!.addressId);
                      }

                      CustomSnackbar.showSnackbar(context,
                          content: "Address updated");
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: useraddressprovider.isDataUpdating == true
                    ? CustomLoader(
                        color: Theme.of(context).colorScheme.background,
                        size: SizeConfig.screenWidth! * .06,
                      )
                    : Icon(
                        FlutterRemix.save_fill,
                        color: Theme.of(context).colorScheme.background,
                        size: SizeConfig.screenWidth! * .06,
                      ),
              ),
            ),
          ),
        ),
      ),
      fabLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  bool validataAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onValueChanged,
  }) : super(key: key);

  final bool value;
  final Function(bool) onValueChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .015),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
          widget.onValueChanged(_isChecked);
        },
        child: Row(
          children: [
            Icon(
              _isChecked
                  ? FlutterRemix.checkbox_circle_fill
                  : FlutterRemix.checkbox_circle_line,
              color: _isChecked
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inversePrimary,
              size: SizeConfig.screenWidth! * .06,
            ),
            SizedBox(width: SizeConfig.screenWidth! * .015),
            const Text("Set as Default Address"),
          ],
        ),
      ),
    );
  }
}
