import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/size.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    this.controller,
    this.inputAction,
    required this.hintTxt,
    this.obscureText = false,
    this.onSave,
    this.node,
    this.capitalization = TextCapitalization.none,
    required this.validator,
    this.isNumberInput = false,
    this.suffixIcon,
    this.maxLength,
    this.isSpaceDenied,
    this.prefixIcon,
    this.autoFocus = false,
    this.hideTitle = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final bool isTextArea = false;
  final bool isNumberInput;
  final bool obscureText;
  final String hintTxt;
  final Function? onSave;
  final FocusNode? node;
  final String? Function(String?) validator;
  final TextCapitalization capitalization;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final bool? isSpaceDenied;
  final bool autoFocus;
  final bool hideTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hideTitle == false)
          SizedBox(height: SizeConfig.screenHeight! * .015),
        if (hideTitle == false)
          Text(
            hintTxt,
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! * .0375,
              fontWeight: FontWeight.w400,
            ),
          ),
        if (hideTitle == false)
          SizedBox(height: SizeConfig.screenHeight! * .01),
        TextFormField(
          autofocus: autoFocus,
          onEditingComplete: onSave != null
              ? () {
                  onSave!();
                }
              : null,
          textInputAction: inputAction,
          inputFormatters: [
            if (isSpaceDenied == true)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          textCapitalization: capitalization,
          controller: controller,
          focusNode: node,
          maxLength: maxLength,
          style: TextStyle(fontSize: SizeConfig.screenWidth! * .0375),
          decoration: InputDecoration(
              hintText: hideTitle ? hintTxt : null,
              hintStyle: TextStyle(
                fontSize: SizeConfig.screenWidth! * .0375,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
              ),
              counterText: "",
              prefixIcon: Padding(
                  padding: prefixIcon != null
                      ? EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenHeight! * .0075)
                      : EdgeInsets.only(left: SizeConfig.screenHeight! * .0075),
                  child: prefixIcon),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .0075),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(0.75),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error, width: 1.5)),
              disabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error, width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5)),
              border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  borderSide:
                      BorderSide(color: Colors.grey[400]!, width: 1.5))),
          obscureText: obscureText,
          maxLines: !isTextArea ? 1 : 3,
          keyboardType:
              isNumberInput ? TextInputType.number : TextInputType.text,
          validator: validator,
        ),
      ],
    );
  }
}
