import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20description/product_description_screen.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/search_query.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/components/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';

import '../product listing/product_listing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, this.isUserScrolling}) : super(key: key);

  final Function(bool)? isUserScrolling;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  late FocusNode _searchBoxFocusNode;

  late SearchProvider _provider;

  late ScrollController _scrollController;

  @override
  void initState() {
    _searchBoxFocusNode = FocusNode();
    _controller = TextEditingController();

    _provider = Provider.of<SearchProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_provider.isDataLoaded == false) {
        _provider.fetchSearchQueryData();
      }
    });

    _scrollController = ScrollController();
    if (widget.isUserScrolling != null) {
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          widget.isUserScrolling!(false);
        } else {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            widget.isUserScrolling!(true);
          }
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _searchBoxFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarIconBrightness:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              FlutterRemix.arrow_left_fill,
              size: SizeConfig.screenWidth! * .06,
            )),
        titleSpacing: SizeConfig.screenHeight! * .015,
        toolbarHeight: SizeConfig.screenWidth! * .15,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.background),
        title: Consumer<SearchProvider>(
            builder: (context, searchprovider, _) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(SizeConfig.screenWidth! * .025),
                        child: Icon(
                          FlutterRemix.search_2_fill,
                          color: Theme.of(context).colorScheme.primary,
                          size: SizeConfig.screenWidth! * .06,
                        ),
                      ),
                      SizedBox(width: SizeConfig.screenWidth! * .01),
                      Expanded(
                        child: TextFormField(
                          focusNode: _searchBoxFocusNode,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _controller,
                          autofocus: true,
                          onFieldSubmitted: (String value) async {
                            if (searchprovider.isDataLoaded == true) {
                              if (_controller.text.isNotEmpty) {
                                final searchQuery = SearchQueryModel()
                                  ..queryText = _controller.text.trim();
                                await searchprovider
                                    .modifySearchQueryList(searchQuery);

                                NavigatorService.push(context,
                                    page: ProductListingScreen(
                                        id: _controller.text.trim(),
                                        name:
                                            'Search: "${_controller.text.trim().toLowerCase()}"',
                                        type: "Search"));

                                if (_searchBoxFocusNode.hasFocus) {
                                  _searchBoxFocusNode.unfocus();
                                }
                              } else {
                                _searchBoxFocusNode.requestFocus();
                              }
                            }
                          },
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth! * .04),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: "Search...",
                              hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                  fontSize: SizeConfig.screenWidth! * .04)),
                        ),
                      ),
                    ],
                  ),
                )),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.screenHeight! * .015),
            RecentSearchesComponent(
              controller: _controller,
              focusNode: _searchBoxFocusNode,
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            const PreviouslyViewedComponent(),
            SizedBox(height: SizeConfig.screenHeight! * .015),
          ],
        ),
      ),
    );
  }
}

class PreviouslyViewedComponent extends StatelessWidget {
  const PreviouslyViewedComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBottomSheetDragHandleWithTitle(
              title: "Previously Viewed",
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            Consumer<SearchProvider>(builder: (context, searchprovider, _) {
              if (searchprovider.allPreviousVisitedProducts.isNotEmpty &&
                  searchprovider.isDataLoaded == true) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        searchprovider.allPreviousVisitedProducts.length,
                        (index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                left: SizeConfig.screenHeight! * .015,
                                right: SizeConfig.screenHeight! * .015)
                            : EdgeInsets.only(
                                right: SizeConfig.screenHeight! * .015),
                        child: InkWell(
                          onTap: () {
                            NavigatorService.push(context,
                                page: ProductDescriptionScreen(
                                    product: searchprovider
                                        .allPreviousVisitedProducts[index]));
                          },
                          child: HomeScreenProductTile(
                              data: searchprovider
                                  .allPreviousVisitedProducts[index]),
                        ),
                      );
                    }),
                  ),
                );
              } else if (searchprovider.isDataLoaded == true &&
                  searchprovider.allPreviousVisitedProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight! * .02),
                    child: Text(
                      "No Previously Viewed Products",
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.7)),
                    ),
                  ),
                );
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * .02),
                  child: CustomLoadingIndicator(
                      indicatorSize: SizeConfig.screenHeight! * .025),
                ),
              );
            }),
            SizedBox(height: SizeConfig.screenHeight! * .015),
          ],
        ),
      ),
    );
  }
}

class RecentSearchesComponent extends StatelessWidget {
  const RecentSearchesComponent({
    Key? key,
    required TextEditingController controller,
    required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        width: SizeConfig.screenWidth!,
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBottomSheetDragHandleWithTitle(
                  title: "Recent Seaches"),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Container(
                width: SizeConfig.screenWidth!,
                padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01)),
                child: Consumer<SearchProvider>(
                    builder: (context, searchprovider, _) {
                  if (searchprovider.isDataLoaded == true &&
                      searchprovider.finalSearchQueryData.isNotEmpty) {
                    return Wrap(
                      runSpacing: SizeConfig.screenWidth! * .035,
                      spacing: SizeConfig.screenWidth! * .035,
                      children: List.generate(
                        searchprovider.finalSearchQueryData.length,
                        (index) {
                          SearchQueryModel data =
                              searchprovider.finalSearchQueryData[index];
                          return InkWell(
                            onTap: () {
                              _controller.text = data.queryText!;
                              _controller.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _controller.text.length));

                              NavigatorService.push(context,
                                  page: ProductListingScreen(
                                      id: _controller.text.trim(),
                                      name:
                                          'Search: "${_controller.text.trim().toLowerCase()}"',
                                      type: "Search"));

                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                              }
                            },
                            child: SearchQueryChips(data: data),
                          );
                        },
                      ),
                    );
                  } else if (searchprovider.isDataLoaded == true &&
                      searchprovider.finalSearchQueryData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight! * .02),
                        child: Text(
                          "No Previous Search Data",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.7)),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.screenHeight! * .02),
                      child: CustomLoadingIndicator(
                          indicatorSize: SizeConfig.screenHeight! * .025),
                    ),
                  );
                }),
              ),
            ]),
      ),
    );
  }
}

class SearchQueryChips extends StatelessWidget {
  const SearchQueryChips({
    Key? key,
    required this.data,
  }) : super(key: key);

  final SearchQueryModel data;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, _) => Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenHeight! * .01,
              vertical: SizeConfig.screenHeight! * .007),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.queryText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: SizeConfig.screenWidth! * .035),
              ),
              SizedBox(width: SizeConfig.screenWidth! * .02),
              InkWell(
                onTap: () async {
                  await searchprovider.removeSeachQueryData(data);
                },
                child: Icon(FlutterRemix.close_line,
                    color: Theme.of(context).colorScheme.secondary,
                    size: SizeConfig.screenHeight! * .02),
              )
            ],
          )),
    );
  }
}
