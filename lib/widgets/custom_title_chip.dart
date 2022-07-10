import 'package:flutter/material.dart';

import '../theme/size.dart';

class CustomTitleChip extends StatelessWidget {
  const CustomTitleChip(
      {Key? key,
      required this.text,
      this.textColor,
      this.size,
      this.padding,
      this.bgColor,
      this.borderRadius})
      : super(key: key);

  final String text;
  final Color? textColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
              vertical: SizeConfig.screenHeight! * .01,
              horizontal: SizeConfig.screenHeight! * .015),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: borderRadius ??
            BorderRadius.circular(SizeConfig.screenHeight! * .01),
      ),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: textColor ?? Theme.of(context).colorScheme.background,
              fontSize: size ?? SizeConfig.screenWidth! * .035,
              fontFamily: "Poppins")),
    );
  }
}
