import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/size.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput(
      {Key? key,
      this.controller,
      this.inputAction,
      required this.hintTxt,
      this.obscureText = false,
      this.onSave,
      this.label,
      this.node,
      this.capitalization = TextCapitalization.none,
      required this.validator,
      this.isNumberInput = false,
      this.formatters,
      this.suffixIcon,
      this.maxLength})
      : super(key: key);

  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final bool isTextArea = false;
  final bool isNumberInput;
  final bool obscureText;
  final String hintTxt;
  final Function? onSave;
  final String? label;
  final FocusNode? node;
  final String? Function(String?) validator;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? formatters;
  final Widget? suffixIcon;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.screenHeight! * .015),
        Text(
          hintTxt,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * .01),
        TextFormField(
          onEditingComplete: onSave != null
              ? () {
                  onSave!();
                }
              : null,
          textInputAction: inputAction,
          inputFormatters: formatters,
          textCapitalization: capitalization,
          controller: controller,
          focusNode: node,
          maxLength: maxLength,
          decoration: InputDecoration(
              counterText: "",
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .015),
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
