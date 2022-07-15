import 'package:cached_network_image/cached_network_image.dart';
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
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
      ),
      child: Column(children: [
        SizedBox(
          height: SizeConfig.screenWidth,
          width: SizeConfig.screenWidth,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageData.length,
            itemBuilder: (context, index) => Container(
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
        ),
        SizedBox(height: SizeConfig.screenWidth! * .015),
        SizedBox(
            height: SizeConfig.screenWidth! * .05,
            width: SizeConfig.screenWidth!,
            child: Center(
                child: SmoothPageIndicator(
              controller: _pageController,
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
    );
  }
}
