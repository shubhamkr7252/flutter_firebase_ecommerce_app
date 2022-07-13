import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/model/home_cms_banner.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_firebase_ecommerce_app/provider/home_cms_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TopBanner extends StatefulWidget {
  const TopBanner({Key? key}) : super(key: key);

  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  late ValueNotifier<int> _currentIndex;

  @override
  void initState() {
    _currentIndex = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCMSProvider>(builder: (context, homecmsprovider, _) {
      if (homecmsprovider.allHomeCMSBannerData != null &&
          homecmsprovider.isBannerDataLoaded == true) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.screenHeight! * .01),
                topRight: Radius.circular(SizeConfig.screenHeight! * .01)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight! * .01),
              ),
              child: Column(children: [
                BannerCarousel(
                  bannerData: homecmsprovider.allHomeCMSBannerData!.banners!,
                  onPageChanged: (int index) {
                    _currentIndex.value = index;
                  },
                ),
                SizedBox(height: SizeConfig.screenWidth! * .015),
                SizedBox(
                    height: SizeConfig.screenWidth! * .05,
                    width: SizeConfig.screenWidth!,
                    child: Center(
                        child: ValueListenableBuilder<int>(
                      valueListenable: _currentIndex,
                      builder: (context, value, child) =>
                          AnimatedSmoothIndicator(
                        activeIndex: value,
                        count: homecmsprovider
                            .allHomeCMSBannerData!.banners!.length,
                        effect: ExpandingDotsEffect(
                          expansionFactor: 3.5,
                          dotColor: Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor!,
                          activeDotColor:
                              Theme.of(context).colorScheme.secondary,
                          dotHeight: 7.0,
                          dotWidth: 7.0,
                        ),
                      ),
                    ))),
                SizedBox(height: SizeConfig.screenWidth! * .015),
              ]),
            ),
          ),
        );
      } else if (homecmsprovider.allHomeCMSBannerData == null &&
          homecmsprovider.isBannerDataLoaded == true) {
        return const Text("No Data");
      }
      return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01),
              width: SizeConfig.screenWidth!,
              height: SizeConfig.screenWidth! * (9 / 16)),
        ),
      );
    });
  }
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel(
      {Key? key, required this.bannerData, required this.onPageChanged})
      : super(key: key);

  final List<HomeCMSBannerObject> bannerData;
  final Function(int) onPageChanged;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;

  late int _currentPage;
  late bool _end;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _currentPage = 0;
    _end = false;

    ///change this duration to change the interval between banner image change
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage == widget.bannerData.length - 1) {
        _end = true;
      } else if (_currentPage == 0) {
        _end = false;
      }

      if (_end == false) {
        _currentPage++;
      } else {
        _currentPage--;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
        widget.onPageChanged(_currentPage);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.bannerData.length,
        onPageChanged: (index) {
          widget.onPageChanged(index);
        },
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: widget.bannerData[index].image!,
            fit: BoxFit.cover,
            placeholder: (context, placeholderImage) => CustomLoader(
              color: Theme.of(context).colorScheme.primary,
              size: SizeConfig.screenWidth! * .15,
            ),
          ),
        ),
      ),
    );
  }
}
