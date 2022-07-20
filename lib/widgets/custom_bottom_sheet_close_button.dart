import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../theme/size.dart';

class CustomBottomSheetCloseButton extends StatelessWidget {
  const CustomBottomSheetCloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.25),
              blurRadius: 2.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        child: Icon(
          FlutterRemix.close_fill,
          color: Theme.of(context).colorScheme.background,
          size: SizeConfig.screenWidth! * .06,
        ),
      ),
    );
  }
}
