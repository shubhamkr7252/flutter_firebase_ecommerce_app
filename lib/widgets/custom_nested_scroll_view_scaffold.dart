import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class CustomNestedScrollViewScaffold extends StatefulWidget {
  const CustomNestedScrollViewScaffold({
    Key? key,
    this.title,
    required this.body,
    this.hideAppbarActions = false,
    this.showSortButton = false,
    this.appBarActions,
    this.customAppBar,
    this.disabelScroll,
    this.fab,
    this.fabLocation,
    this.floatingHeaderSlivers,
  }) : super(key: key);

  final String? title;
  final Widget body;
  final bool hideAppbarActions;
  final bool showSortButton;
  final List<Widget>? appBarActions;
  final List<SliverAppBar>? customAppBar;
  final bool? disabelScroll;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;
  final bool? floatingHeaderSlivers;

  @override
  State<CustomNestedScrollViewScaffold> createState() =>
      _CustomNestedScrollViewScaffoldState();
}

class _CustomNestedScrollViewScaffoldState
    extends State<CustomNestedScrollViewScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
        ),
        child: ColorfulSafeArea(
          color: Theme.of(context).colorScheme.primary,
          child: NestedScrollView(
            floatHeaderSlivers: widget.floatingHeaderSlivers ?? true,
            physics:
                widget.disabelScroll != null && widget.disabelScroll == true
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => widget
                        .customAppBar ==
                    null
                ? [
                    SliverAppBar(
                        leading: IconButton(
                            splashRadius: SizeConfig.screenWidth! * .05,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(FlutterRemix.arrow_left_fill,
                                size: SizeConfig.screenWidth! * .06)),
                        toolbarHeight: SizeConfig.screenWidth! * .15,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        floating: true,
                        snap: true,
                        pinned: false,
                        automaticallyImplyLeading: true,
                        iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.background,
                        ),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: SizeConfig.screenWidth! * .04,
                                      fontFamily: "Poppins"),
                                ),
                              )
                            : null,
                        titleSpacing: 0.0,
                        actions: widget.appBarActions)
                  ]
                : widget.customAppBar!,
            body: widget.body,
          ),
        ),
      ),
    );
  }
}
