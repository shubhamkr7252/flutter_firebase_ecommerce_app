import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.imageData,
  }) : super(key: key);

  final List<String> imageData;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late final ValueNotifier<int> _currentIndex;

  @override
  void initState() {
    _currentIndex = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentIndex,
      builder: (_, __, ___) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
        ),
        child: Column(children: [
          CarouselSlider(
            carouselController: CarouselController(),
            items: List.generate(
              widget.imageData.length,
              (index) => Container(
                height: SizeConfig.screenWidth,
                width: SizeConfig.screenWidth,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageData[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            options: CarouselOptions(
              aspectRatio: 1 / 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                _currentIndex.value = index;
              },
              viewportFraction: 1,
              autoPlay: false,
            ),
          ),
          SizedBox(height: SizeConfig.screenWidth! * .015),
          SizedBox(
              height: SizeConfig.screenWidth! * .05,
              width: SizeConfig.screenWidth!,
              child: Center(
                  child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex.value,
                count: widget.imageData.length,
                effect: ExpandingDotsEffect(
                  expansionFactor: 3.5,
                  dotColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
                  activeDotColor: Theme.of(context).colorScheme.secondary,
                  dotHeight: 7.0,
                  dotWidth: 7.0,
                ),
              ))),
          SizedBox(height: SizeConfig.screenWidth! * .015),
        ]),
      ),
    );
  }
}
