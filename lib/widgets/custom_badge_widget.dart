import 'package:flutter/material.dart';

import '../theme/size.dart';
import '../utils/cart_color.dart';

class CustomBadgeWidget extends StatelessWidget {
  const CustomBadgeWidget({
    Key? key,
    required this.number,
  }) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: number < 99 ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            number < 99 ? null : BorderRadius.circular(SizeConfig.screenWidth!),
        color: CartColor.getColor(context),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 8.5,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
