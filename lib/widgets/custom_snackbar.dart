import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:oktoast/oktoast.dart';
import '../theme/size.dart';
import '../utils/cart_color.dart';

class CustomSnackbar {
  static void showSnackbar(
    BuildContext context, {
    required String title,
    int type = 0,
    String? description,
    Duration? duration,
    ToastPosition? position,
  }) {
    showToastWidget(
        CustomSnackbarWidget(
          mainContext: context,
          type: type,
          title: title,
          description: description,
        ),
        animationCurve: Curves.fastOutSlowIn,
        duration: duration ?? const Duration(seconds: 2),
        position: position ?? ToastPosition.bottom);
  }
}

class CustomSnackbarWidget extends StatelessWidget {
  const CustomSnackbarWidget({
    Key? key,
    required this.mainContext,
    this.type = 0,
    required this.title,
    this.description,
  }) : super(key: key);

  final BuildContext mainContext;

  ///type 0 = Information
  ///type 1 = Success
  ///type 2 = Error
  final int type;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (type > 2) {
      throw "type < 3 is not true";
    }
    if (type < 0) {
      throw "type > -1 is not true";
    }
    final Color _bgColor = (type == 2
        ? Theme.of(mainContext).colorScheme.error
        : (type == 1
            ? CartColor.getColor(mainContext)
            : Theme.of(mainContext).colorScheme.primary));
    final IconData _icon = (type == 2
        ? FlutterRemix.close_circle_fill
        : (type == 1
            ? FlutterRemix.checkbox_circle_fill
            : FlutterRemix.information_fill));
    return Container(
      width: SizeConfig.screenWidth! * .9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(mainContext)
                .colorScheme
                .inversePrimary
                .withOpacity(0.25),
            blurRadius: 2.0,
          ),
        ],
        color: Theme.of(mainContext).cardTheme.color,
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
      ),
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _icon,
            size: SizeConfig.screenWidth! * .06,
            color: _bgColor,
          ),
          SizedBox(width: SizeConfig.screenHeight! * .015),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(mainContext).textTheme.bodyText1!.color,
                    fontSize: SizeConfig.screenWidth! * .0365,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
                if (description != null)
                  SizedBox(height: SizeConfig.screenWidth! * .01),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyle(
                      color: Theme.of(mainContext)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.65),
                      fontSize: SizeConfig.screenWidth! * .0335,
                      fontFamily: "Poppins",
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
