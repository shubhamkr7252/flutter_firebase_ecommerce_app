import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';

import '../theme/size.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPress,
    this.bgColor,
    this.width,
    this.fontSize,
    this.textColor,
    this.height,
    this.borderRadius,
    this.icon,
  }) : super(key: key);

  final String buttonText;
  final IconData? icon;
  final Function onPress;
  final Color? bgColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? textColor;
  final BorderRadius? borderRadius;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? SizeConfig.screenWidth! * .115,
      width: widget.width ?? SizeConfig.screenWidth!,
      child: TapDebouncer(
        onTap: () async {
          await widget.onPress();
        },
        builder: (BuildContext context, TapDebouncerFunc? onTap) =>
            ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all(SizeConfig.screenWidth! * .0025),
              backgroundColor: widget.bgColor != null
                  ? MaterialStateProperty.all(widget.bgColor)
                  : MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(SizeConfig.screenHeight! * .01)))),
          child: onTap == null
              ? CustomLoader(
                  color: widget.textColor ??
                      Theme.of(context).colorScheme.background,
                  size: SizeConfig.screenWidth! * .06)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null)
                      Icon(widget.icon,
                          color: widget.textColor ??
                              Theme.of(context).colorScheme.background,
                          size: SizeConfig.screenWidth! * .06),
                    if (widget.icon != null)
                      SizedBox(width: SizeConfig.screenWidth! * .015),
                    Flexible(
                      child: Text(widget.buttonText,
                          style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).colorScheme.background,
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
