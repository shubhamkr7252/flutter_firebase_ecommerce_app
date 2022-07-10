import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../theme/size.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    Key? key,
    this.title,
    required this.body,
    this.fab,
    this.fabLocation,
    this.customAppBar,
    this.resizeToAvoidBottomInset = false,
    this.showAppbar,
    this.appBarActions,
  }) : super(key: key);

  final String? title;
  final Widget body;
  final Widget? fab;
  final bool? showAppbar;
  final FloatingActionButtonLocation? fabLocation;
  final AppBar? customAppBar;
  final bool? resizeToAvoidBottomInset;
  final List<Widget>? appBarActions;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.primary,
        statusBarIconBrightness:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Brightness.light
                : Brightness.dark,
      ),
      child: ColorfulSafeArea(
        color: Theme.of(context).colorScheme.primary,
        child: Scaffold(
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          appBar: widget.customAppBar == null && widget.showAppbar != false
              ? AppBar(
                  elevation: SizeConfig.screenWidth! * .005,
                  toolbarHeight: SizeConfig.screenWidth! * .15,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        FlutterRemix.arrow_left_fill,
                        size: SizeConfig.screenWidth! * .06,
                      )),
                  title: widget.title != null && widget.title!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.screenHeight! * .015,
                            right: SizeConfig.screenHeight! * .015,
                          ),
                          child: Text(
                            widget.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: SizeConfig.screenWidth! * .04,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          ),
                        )
                      : null,
                  titleSpacing: widget.title != null && widget.title!.isNotEmpty
                      ? 0.0
                      : SizeConfig.screenWidth! * .015,
                  actions: widget.appBarActions ?? [],
                )
              : widget.customAppBar,
          body: widget.body,
          floatingActionButton: widget.fab,
          floatingActionButtonLocation: widget.fabLocation,
        ),
      ),
    );
  }
}
