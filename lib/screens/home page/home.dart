import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/home_cms_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20page/components/home_brands.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20page/components/home_categories.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20page/components/home_cms_highlights.dart';
import 'package:flutter_firebase_ecommerce_app/screens/home%20page/components/top_banner.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeCMSProvider _provider;
  late WishlistProvider _wishlistProvider;
  late UserProvider _userProvider;
  late CartProvider _cartProvider;

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
        _provider.fetchCMSHomeHighlightsData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCMSProvider>(
      builder: (context, homecmsprovider, _) => Scaffold(
        body: Consumer<HomeCMSProvider>(
          builder: (context, homecmsprovider, _) => SingleChildScrollView(
            primary: homecmsprovider.isHighlightsDataLoaded == true &&
                homecmsprovider.isBannerDataLoaded == true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight! * .015),
                const HomeCategories(),
                SizedBox(height: SizeConfig.screenHeight! * .015),
                const HomeBrands(),
                SizedBox(height: SizeConfig.screenHeight! * .015),
                const TopBanner(),
                SizedBox(height: SizeConfig.screenHeight! * .015),
                Consumer<HomeCMSProvider>(
                    builder: (context, homecmsprovider, _) {
                  if (homecmsprovider.allHomeCMSHighlightsData != null &&
                      homecmsprovider.isHighlightsDataLoaded == true) {
                    return ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, outerIndex) {
                          return HomeCMSHighlightsComponent(
                              data: homecmsprovider
                                  .allHomeCMSHighlightsData![outerIndex]);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: SizeConfig.screenHeight! * .015),
                        itemCount:
                            homecmsprovider.allHomeCMSHighlightsData!.length);
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
        ),
      ),
    );
  }
}
