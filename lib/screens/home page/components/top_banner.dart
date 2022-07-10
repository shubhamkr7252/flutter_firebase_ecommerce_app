import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_firebase_ecommerce_app/provider/home_cms_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';

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
        return ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (_, __, ___) => Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
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
                  CarouselSlider(
                    carouselController: CarouselController(),
                    items: List.generate(
                        homecmsprovider.allHomeCMSBannerData!.banners!.length,
                        (index) {
                      var data =
                          homecmsprovider.allHomeCMSBannerData!.banners![index];
                      return InkWell(
                          onTap: () {
                            // NavigatorService.push(context,
                            //     page: ProductList(
                            //         id: data.title!,
                            //         name: "",
                            //         type: data.type!));
                          },
                          child: CachedNetworkImage(
                              imageUrl: data.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, placeholderImage) =>
                                  CustomLoader(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: SizeConfig.screenWidth! * .15,
                                  )));
                    }),
                    options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          _currentIndex.value = index;
                        },
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 10)),
                  ),
                  SizedBox(height: SizeConfig.screenWidth! * .015),
                  SizedBox(
                      height: SizeConfig.screenWidth! * .05,
                      width: SizeConfig.screenWidth!,
                      child: Center(
                          child: AnimatedSmoothIndicator(
                        activeIndex: _currentIndex.value,
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
                      ))),
                  SizedBox(height: SizeConfig.screenWidth! * .015),
                ]),
              ),
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
