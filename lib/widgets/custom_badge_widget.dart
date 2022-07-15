import 'package:flutter/material.dart';

class CustomBadgeWidget extends StatelessWidget {
  const CustomBadgeWidget({
    Key? key,
    required this.number,
    this.bgColor,
  }) : super(key: key);

  final int number;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.25),
              blurRadius: 2.0,
            ),
          ]),
      alignment: Alignment.center,
      child: Text(
        number > 9 ? "9+" : number.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 8.5,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
