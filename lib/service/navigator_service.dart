import 'package:flutter/cupertino.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class NavigatorService {
  static void push(BuildContext context, {required Widget page}) {
    Navigator.of(context).push(SwipeablePageRoute(
        builder: (context) => page, canOnlySwipeFromEdge: true));
  }

  static void pushReplace(BuildContext context,
      {required Widget page, bool? edgeOnly}) {
    Navigator.of(context).pushReplacement(SwipeablePageRoute(
        builder: (context) => page, canOnlySwipeFromEdge: true));
  }

  static void pushReplaceUntil(BuildContext context,
      {required Widget page, bool? edgeOnly}) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushAndRemoveUntil(
        SwipeablePageRoute(
            builder: (context) => page, canOnlySwipeFromEdge: true),
        (route) => false);
  }
}
