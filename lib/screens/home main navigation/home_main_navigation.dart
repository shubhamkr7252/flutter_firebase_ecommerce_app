import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/home_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart/my_cart_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/notification/notification_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/profile_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/search/search_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20main%20navigation/voice_search_bottom_sheet.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_badge_widget.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/all%20categories/all_categories_screen.dart';
import 'package:flutter_firebase_ecommerce_app/theme/colors.dart';
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
        "activeIcon": FlutterRemix.notification_4_fill,
        "inactiveIcon": FlutterRemix.notification_4_line,
        "title": "Notifications"
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
      NotificationScreen(userId: _userProvider.getCurrentUser!.id!),
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
                      Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      const VoiceSearchBottomSheet());
                            },
                            icon: Icon(
                              FlutterRemix.mic_2_fill,
                              size: SizeConfig.screenWidth! * .06,
                              color: Theme.of(context).colorScheme.background,
                            )),
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
            builder: (context, value, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _screens.elementAt(value),
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
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.25),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: Consumer<CartProvider>(
              builder: (context, cartprovider, _) =>
                  Consumer<NotificationProvider>(
                builder: (context, notificationprovider, _) => Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: value,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    showUnselectedLabels: false,
                    showSelectedLabels: false,
                    type: BottomNavigationBarType.fixed,
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    selectedItemColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    // selectedLabelStyle: const TextStyle(
                    //     fontWeight: FontWeight.bold, fontSize: 12.5),
                    // unselectedLabelStyle: const TextStyle(fontSize: 12.5),
                    onTap: (index) {
                      _currentIndex.value = index;
                    },
                    items: [
                      ///home tile
                      cutomBottomNavigationBar(
                          icon: _screenBottomNavigationItemData[0]
                              ["inactiveIcon"],
                          activeIcon: _screenBottomNavigationItemData[0]
                              ["activeIcon"],
                          label: _screenBottomNavigationItemData[0]["title"]),

                      ///categories tile
                      cutomBottomNavigationBar(
                          icon: _screenBottomNavigationItemData[1]
                              ["inactiveIcon"],
                          activeIcon: _screenBottomNavigationItemData[1]
                              ["activeIcon"],
                          label: _screenBottomNavigationItemData[1]["title"]),

                      ///notifications tile
                      cutomBottomNavigationBar(
                          icon: _screenBottomNavigationItemData[2]
                              ["inactiveIcon"],
                          activeIcon: _screenBottomNavigationItemData[2]
                              ["activeIcon"],
                          badgeNumber:
                              notificationprovider.allNotificationData.length,
                          label: _screenBottomNavigationItemData[2]["title"]),

                      ///cart tile
                      cutomBottomNavigationBar(
                          icon: _screenBottomNavigationItemData[3]
                              ["inactiveIcon"],
                          activeIcon: _screenBottomNavigationItemData[3]
                              ["activeIcon"],
                          badgeNumber: cartprovider.allCartData != null &&
                                  cartprovider.allCartData!.products!.isNotEmpty
                              ? cartprovider.allCartData!.products!.length
                              : null,
                          label: _screenBottomNavigationItemData[3]["title"]),

                      ///profile tile
                      cutomBottomNavigationBar(
                          icon: _screenBottomNavigationItemData[4]
                              ["inactiveIcon"],
                          activeIcon: _screenBottomNavigationItemData[4]
                              ["activeIcon"],
                          label: _screenBottomNavigationItemData[4]["title"]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem cutomBottomNavigationBar({
    required IconData icon,
    required IconData activeIcon,
    int? badgeNumber,
    required String label,
  }) {
    return BottomNavigationBarItem(
        icon: Stack(
          children: [
            Icon(icon),
            if (badgeNumber != null && badgeNumber != 0)
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topRight,
                child: CustomBadgeWidget(
                  number: badgeNumber,
                ),
              ))
          ],
        ),
        activeIcon: Stack(
          children: [
            Icon(activeIcon),
            if (badgeNumber != null && badgeNumber != 0)
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topRight,
                child: CustomBadgeWidget(number: badgeNumber),
              ))
          ],
        ),
        tooltip: "",
        label: label);
  }
}
