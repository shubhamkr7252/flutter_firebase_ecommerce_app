import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/home_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/my_cart_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/notification/notification_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/profile_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/search/search_screen.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_badge_widget.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/all%20categories/all_categories_screen.dart';
import 'package:flutter_firebase_ecommerce_app/theme/colors.dart';
import '../../service/navigator_service.dart';
import '../../theme/size.dart';

class HomeMainNavigation extends StatefulWidget {
  const HomeMainNavigation({Key? key}) : super(key: key);

  @override
  _HomeMainNavigationState createState() => _HomeMainNavigationState();
}

class _HomeMainNavigationState extends State<HomeMainNavigation> {
  late CartProvider _cartProvider;
  late UserProvider _userProvider;
  late NotificationProvider _notificationProvider;

  late List<Widget> _screens;
  late ValueNotifier<int> _currentIndex;
  late PageController _pageController;
  late List<Map<String, dynamic>> _screenBottomNavigationItemData;

  @override
  void dispose() {
    _currentIndex.dispose();
    _pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _cartProvider = Provider.of(context, listen: false);
    _userProvider = Provider.of(context, listen: false);
    _notificationProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_cartProvider.isDataLoaded == false) {
        _cartProvider.fetchCartData(userId: _userProvider.getCurrentUser!.id!);
      }
      if (_notificationProvider.isDataLoaded == false) {
        _notificationProvider.fetchNotificationData(
            userId: _userProvider.getCurrentUser!.id!);
      }
    });

    _pageController = PageController();
    _screenBottomNavigationItemData = [
      {
        "activeIcon": FlutterRemix.home_6_fill,
        "inactiveIcon": FlutterRemix.home_6_line,
        "title": "Home"
      },
      {
        "activeIcon": FlutterRemix.layout_4_fill,
        "inactiveIcon": FlutterRemix.layout_4_line,
        "title": "Categories"
      },
      {
        "activeIcon": FlutterRemix.shopping_cart_2_fill,
        "inactiveIcon": FlutterRemix.shopping_cart_2_line,
        "title": "My Cart"
      },
      {
        "activeIcon": FlutterRemix.user_3_fill,
        "inactiveIcon": FlutterRemix.user_3_line,
        "title": "Profile"
      },
    ];

    _screens = [
      const HomeScreen(),
      const AllCategoriesScreen(),
      const MyCartScreen(),
      const ProfileScreen(),
    ];

    _currentIndex = ValueNotifier<int>(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: ColorOperations.shimmerGradient(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          titleSpacing: SizeConfig.screenHeight! * .015,
          automaticallyImplyLeading: false,
          toolbarHeight: SizeConfig.screenWidth! * .15,
          elevation: SizeConfig.screenWidth! * .005,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.primary,
              statusBarIconBrightness:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Brightness.dark
                      : Brightness.light),
          title: Consumer<SearchProvider>(
              builder: (context, searchprovider, _) => Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenHeight! * .01)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    SizeConfig.screenWidth! * .025),
                                child: Icon(
                                  FlutterRemix.search_2_fill,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: SizeConfig.screenWidth! * .06,
                                ),
                              ),
                              SizedBox(width: SizeConfig.screenWidth! * .01),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const SearchScreen(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero));
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.screenWidth! * .04),
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
                                            fontSize:
                                                SizeConfig.screenWidth! * .04)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<UserProvider>(
                        builder: (context, userprovider, _) => Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth! * .03),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight! * .01),
                            onTap: () {
                              NavigatorService.push(context,
                                  page: NotificationScreen(
                                      userId:
                                          userprovider.getCurrentUser!.id!));
                            },
                            child: Consumer<NotificationProvider>(
                              builder: (context, notificationprovider, _) =>
                                  Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.screenWidth! * .015),
                                child: Stack(
                                  children: [
                                    if (notificationprovider.isDataLoaded ==
                                            true &&
                                        notificationprovider
                                            .allNotificationData.isNotEmpty)
                                      Icon(
                                        FlutterRemix.notification_3_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withOpacity(0.75),
                                        size: SizeConfig.screenWidth! * .06,
                                      ),
                                    Icon(
                                      FlutterRemix.notification_3_line,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      size: SizeConfig.screenWidth! * .06,
                                    ),
                                    // if (notificationprovider.isDataLoaded ==
                                    //         true &&
                                    //     notificationprovider
                                    //         .allNotificationData.isNotEmpty)
                                    //   Positioned.fill(
                                    //     child: Align(
                                    //       alignment: Alignment.topRight,
                                    //       child: CustomBadgeWidget(
                                    //         bgColor: Theme.of(context)
                                    //             .colorScheme
                                    //             .error,
                                    //       ),
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: const Text(
              'Tap back again to leave',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, value, child) => PageView.builder(
              itemBuilder: (context, index) => _screens[index],
              itemCount: _screens.length,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, _) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(0.25),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: Consumer<CartProvider>(
              builder: (context, cartprovider, _) => Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  currentIndex: value,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor:
                      Theme.of(context).colorScheme.inversePrimary,
                  selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12.5),
                  unselectedLabelStyle: const TextStyle(fontSize: 12.5),
                  onTap: (index) {
                    _currentIndex.value = index;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[0]
                                ["inactiveIcon"])),
                        activeIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[0]
                                ["activeIcon"])),
                        tooltip: "",
                        label: _screenBottomNavigationItemData[0]["title"]),
                    BottomNavigationBarItem(
                        icon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[1]
                                ["inactiveIcon"])),
                        activeIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[1]
                                ["activeIcon"])),
                        tooltip: "",
                        label: _screenBottomNavigationItemData[1]["title"]),
                    BottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.5),
                                child: Icon(_screenBottomNavigationItemData[2]
                                    ["inactiveIcon"])),
                            if (cartprovider.isDataLoaded == true &&
                                cartprovider.allCartData!.products!.isNotEmpty)
                              Positioned.fill(
                                  child: Align(
                                alignment: Alignment.topRight,
                                child: CustomBadgeWidget(
                                  number: cartprovider
                                      .allCartData!.products!.length,
                                ),
                              ))
                          ],
                        ),
                        activeIcon: Stack(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.5),
                                child: Icon(_screenBottomNavigationItemData[2]
                                    ["activeIcon"])),
                            if (cartprovider.isDataLoaded == true &&
                                cartprovider.allCartData!.products!.isNotEmpty)
                              Positioned.fill(
                                  child: Align(
                                alignment: Alignment.topRight,
                                child: CustomBadgeWidget(
                                    number: cartprovider
                                        .allCartData!.products!.length),
                              ))
                          ],
                        ),
                        tooltip: "",
                        label: _screenBottomNavigationItemData[2]["title"]),
                    BottomNavigationBarItem(
                        icon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[3]
                                ["inactiveIcon"])),
                        activeIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.5),
                            child: Icon(_screenBottomNavigationItemData[3]
                                ["activeIcon"])),
                        tooltip: "",
                        label: _screenBottomNavigationItemData[3]["title"]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
