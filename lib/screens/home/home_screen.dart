import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/home_cms_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/components/home_categories.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/components/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home/components/top_banner.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

import '../../widgets/custom_loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCMSProvider _provider;
  late WishlistProvider _wishlistProvider;
  late UserProvider _userProvider;
  late CartProvider _cartProvider;

  late ValueNotifier<bool> _isDataLoading;
  late ScrollController _scrollController;

  @override
  void initState() {
    _provider = Provider.of<HomeCMSProvider>(context, listen: false);
    _wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _cartProvider = Provider.of<CartProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_wishlistProvider.isDataLoaded == false &&
          _userProvider.getCurrentUser != null) {
        _wishlistProvider.fetchWishlistData(
            userId: _userProvider.getCurrentUser!.id.toString());
      }

      if (_cartProvider.isDataLoaded == false) {
        if (_userProvider.getCurrentUser != null) {
          _cartProvider.fetchCartData(
              userId: _userProvider.getCurrentUser!.id.toString());
        }
      }

      if (_provider.isBannerDataLoaded == false) {
        _provider.fetchCMSHomeBannerData();
      }
      if (_provider.isHighlightsDataLoaded == false) {
        _provider.fetchCMSHomeHighlightsBlueprintData();
      }
    });

    _isDataLoading = ValueNotifier<bool>(false);

    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_provider.isHighlightsDataLoaded == false &&
            _provider.isBannerDataLoaded == false) {
          return;
        }
        if (_provider.allHomeCMSHighlightsBlueprintData.length ==
            _provider.allHomeCMSHighlightsData.length) {
          return;
        } else {
          _isDataLoading.value = true;
          await _provider.fetchCMSHomeHighlightsData(
            data: _provider.allHomeCMSHighlightsBlueprintData[
                _provider.allHomeCMSHighlightsData.length],
          );
          _isDataLoading.value = false;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isDataLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCMSProvider>(
      builder: (context, homecmsprovider, _) => Scaffold(
        body: Consumer<HomeCMSProvider>(
          builder: (context, homecmsprovider, _) =>
              ValueListenableBuilder<bool>(
            valueListenable: _isDataLoading,
            builder: (context, value, child) => Stack(
              children: [
                SingleChildScrollView(
                  controller: homecmsprovider.isHighlightsDataLoaded == true &&
                          homecmsprovider.isBannerDataLoaded == true
                      ? _scrollController
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                      const TopBanner(),
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                      const HomeCategories(),
                      // SizedBox(height: SizeConfig.screenHeight! * .015),
                      // const HomeBrands(),
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                      Consumer<HomeCMSProvider>(
                          builder: (context, homecmsprovider, _) {
                        if (homecmsprovider.isHighlightsDataLoaded == true) {
                          return ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, outerIndex) {
                                return HomeCMSHighlightsComponent(
                                    data: homecmsprovider
                                        .allHomeCMSHighlightsData[outerIndex]);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                  height: SizeConfig.screenHeight! * .015),
                              itemCount: homecmsprovider
                                  .allHomeCMSHighlightsData.length);
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenHeight! * .015),
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: SizeConfig.screenWidth! * .925,
                                width: SizeConfig.screenWidth!,
                                child: SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.screenHeight! * .01)),
                                ),
                              );
                            },
                            itemCount: 2,
                            separatorBuilder: (context, index) => SizedBox(
                              height: SizeConfig.screenHeight! * .015,
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: SizeConfig.screenHeight! * .015),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSlide(
                      offset: value == true
                          ? const Offset(0, 0)
                          : const Offset(0, 1),
                      duration: const Duration(milliseconds: 300),
                      child: CustomLoadingIndicator(
                          indicatorSize: SizeConfig.screenWidth! * .055),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
