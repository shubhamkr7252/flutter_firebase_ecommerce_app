import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/all%20categories/all_categories.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20page/home.dart';
import 'package:flutter_firebase_ecommerce_app/screens/notification%20page/notification_page.dart';
import 'package:flutter_firebase_ecommerce_app/screens/search%20page/search_page.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/colors.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20cart%20page/my_cart.dart';
import '../../theme/size.dart';
import '../profile page/profile_bottom_sheet.dart';

class HomeMainNavigation extends StatefulWidget {
  const HomeMainNavigation({Key? key}) : super(key: key);

  @override
  _HomeMainNavigationState createState() => _HomeMainNavigationState();
}

class _HomeMainNavigationState extends State<HomeMainNavigation> {
  late List<Widget> _screens;
  late CartProvider _cartProvider;
  late UserProvider _userProvider;

  late ValueNotifier<int> _currentIndex;
  late PreloadPageController _pageController;
  late List<Map<String, dynamic>> _screenBottomNavigationItemData;

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _cartProvider = Provider.of(context, listen: false);
    _userProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_cartProvider.isDataLoaded == false) {
        _cartProvider.fetchCartData(userId: _userProvider.getCurrentUser!.id!);
      }
    });

    _pageController = PreloadPageController();
    _screenBottomNavigationItemData = [
      {
        "activeIcon": FlutterRemix.home_6_fill,
        "inactiveIcon": FlutterRemix.home_6_line,
        "title": "Home"
      },
      {
        "activeIcon": FlutterRemix.layout_4_fill,
        "inactiveIcon": FlutterRemix.layout_4_line,
        "title": "Catalog"
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
      const Home(),
      const AllCategories(),
      const MyCart(),
      const SizedBox(),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                            onPressed: () {
                              NavigatorService.push(context,
                                  page: const NotificationPage());
                            },
                            icon: Icon(
                              FlutterRemix.notification_3_fill,
                              color: Theme.of(context).colorScheme.background,
                              size: SizeConfig.screenWidth! * .055,
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
            builder: (context, value, child) => PreloadPageView.builder(
              itemBuilder: (context, index) => _screens[index],
              itemCount: _screens.length,
              controller: _pageController,
              preloadPagesCount: 2,
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
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12.5),
                  unselectedLabelStyle: const TextStyle(fontSize: 12.5),
                  onTap: (index) {
                    if (index != _screens.length - 1) {
                      _currentIndex.value = index;
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    } else {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => const ProfileBottomSheet());
                    }
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
                                child: BadgeContainer(
                                    number: cartprovider
                                        .allCartData!.products!.length),
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
                                child: BadgeContainer(
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

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({
    Key? key,
    required this.number,
  }) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: number < 99 ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            number < 99 ? null : BorderRadius.circular(SizeConfig.screenWidth!),
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.green[300]
            : Colors.green,
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 8.5,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
