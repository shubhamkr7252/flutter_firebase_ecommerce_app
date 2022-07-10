import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../../../theme/size.dart';
import '../../profile page/profile_bottom_sheet.dart';

class HomeBottomNavigation extends StatefulWidget {
  const HomeBottomNavigation({Key? key, required this.onIndexChanged})
      : super(key: key);

  final Function(int) onIndexChanged;

  @override
  State<HomeBottomNavigation> createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends State<HomeBottomNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Container(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! * .01),
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color:
            //         MediaQuery.of(context).platformBrightness == Brightness.light
            //             ? ColorInterpolation.lighten(
            //                 Theme.of(context)
            //                     .bottomNavigationBarTheme
            //                     .unselectedItemColor!,
            //                 .35)
            //             : ColorInterpolation.darken(
            //                 Theme.of(context)
            //                     .bottomNavigationBarTheme
            //                     .unselectedItemColor!,
            //                 .35),
            //     blurRadius: 3.0,
            //   ),
            // ],
            color: Theme.of(context).colorScheme.background,
            // borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeBottomNavigationItem(
                currentIndex: _currentIndex,
                callback: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  widget.onIndexChanged(_currentIndex);
                },
                activeIcon: FlutterRemix.home_6_fill,
                inactiveIcon: FlutterRemix.home_6_line,
                index: 0,
                totalLength: 3,
                title: 'Home',
              ),
              // HomeBottomNavigationItem(
              //   currentIndex: _currentIndex,
              //   callback: () {
              //     setState(() {
              //       _currentIndex = 1;
              //     });
              //     widget.onIndexChanged(_currentIndex);
              //   },
              //   activeIcon: FlutterRemix.search_2_fill,
              //   inactiveIcon: FlutterRemix.search_2_line,
              //   index: 1,
              //   totalLength: 4, title: 'Explore',
              // ),
              HomeBottomNavigationItem(
                currentIndex: _currentIndex,
                callback: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  widget.onIndexChanged(_currentIndex);
                },
                activeIcon: FlutterRemix.shopping_bag_2_fill,
                inactiveIcon: FlutterRemix.shopping_bag_2_line,
                index: 2,
                totalLength: 3,
                title: 'My Cart',
              ),
              HomeBottomNavigationItem(
                currentIndex: _currentIndex,
                callback: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) {
                        return const ProfileBottomSheet();
                      });
                },
                activeIcon: FlutterRemix.user_3_fill,
                inactiveIcon: FlutterRemix.user_3_line,
                index: 3,
                totalLength: 3,
                title: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeBottomNavigationItem extends StatelessWidget {
  const HomeBottomNavigationItem(
      {Key? key,
      required this.currentIndex,
      required this.callback,
      required this.activeIcon,
      required this.index,
      required this.title,
      required this.inactiveIcon,
      required this.totalLength})
      : super(key: key);

  final int currentIndex;
  final int index;
  final int totalLength;
  final String title;
  final VoidCallback callback;
  final IconData activeIcon;
  final IconData inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          onTap: () {
            callback();
          },
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          highlightColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
          child: Container(
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: currentIndex == index
                    ? BorderRadius.circular(SizeConfig.screenHeight! * .01)
                    : BorderRadius.zero,
              ),
              padding: EdgeInsets.all(SizeConfig.screenHeight! * .01),
              child: Row(
                children: [
                  Icon(
                    currentIndex == index ? activeIcon : inactiveIcon,
                    color: currentIndex == index
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                    size: SizeConfig.screenHeight! * .03,
                  ),
                  if (currentIndex == index)
                    SizedBox(width: SizeConfig.screenHeight! * .005),
                  if (currentIndex == index)
                    Text(
                      title,
                      style: TextStyle(
                        color: currentIndex == index
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context)
                                .bottomNavigationBarTheme
                                .unselectedItemColor,
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}
