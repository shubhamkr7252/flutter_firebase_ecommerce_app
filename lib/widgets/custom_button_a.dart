import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';

import '../theme/size.dart';

class CustomButtonA extends StatefulWidget {
  const CustomButtonA({
    Key? key,
    required this.buttonText,
    required this.onPress,
    this.width,
    this.fontSize,
    this.textColor,
    this.height,
    this.icon,
  }) : super(key: key);

  final String buttonText;
  final IconData? icon;
  final Function onPress;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? textColor;

  @override
  State<CustomButtonA> createState() => _CustomButtonAState();
}

class _CustomButtonAState extends State<CustomButtonA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth!)),
      height: widget.height ?? SizeConfig.screenWidth! * .135,
      width: widget.width ?? SizeConfig.screenWidth!,
      child: TapDebouncer(
        onTap: () async {
          await widget.onPress();
        },
        builder: (BuildContext context, TapDebouncerFunc? onTap) =>
            OutlinedButton(
          onPressed: onTap,
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(
              width: 2.25,
              color: widget.textColor ?? Theme.of(context).colorScheme.primary,
            )),
            backgroundColor: MaterialStateProperty.all(
                (widget.textColor ?? Theme.of(context).colorScheme.primary)
                    .withOpacity(0.075)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.screenWidth!),
              ),
            ),
          ),
          child: onTap == null
              ? CustomLoader(
                  color:
                      widget.textColor ?? Theme.of(context).colorScheme.primary,
                  size: SizeConfig.screenWidth! * .06)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      Icon(widget.icon,
                          color: widget.textColor ??
                              Theme.of(context).colorScheme.primary,
                          size: SizeConfig.screenWidth! * .06),
                    if (widget.icon != null)
                      SizedBox(width: SizeConfig.screenWidth! * .02),
                    Flexible(
                      child: Text(widget.buttonText,
                          style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).colorScheme.primary,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.screenWidth! * .0325,
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
