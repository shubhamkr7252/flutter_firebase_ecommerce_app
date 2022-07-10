import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_elevated_button.dart';

class OrderPlacedSuccessScreen extends StatefulWidget {
  const OrderPlacedSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedSuccessScreen> createState() =>
      _OrderPlacedSuccessScreenState();
}

class _OrderPlacedSuccessScreenState extends State<OrderPlacedSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieAnimationController;
  late AnimationController _textAnimationController;

  @override
  void initState() {
    _lottieAnimationController = AnimationController(vsync: this);
    _lottieAnimationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 250));
        // Navigator.of(context).pop();
        // _lottieAnimationController.reset();
        // _textAnimationController.reset();
      }
    });

    _textAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    super.initState();
  }

  @override
  void dispose() {
    _lottieAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
        statusBarIconBrightness:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        body: Center(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            width: SizeConfig.screenWidth!,
            height: SizeConfig.screenHeight!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  "assets/lottie_files/order_placed.json",
                  width: SizeConfig.screenWidth! * .75,
                  height: SizeConfig.screenWidth! * .75,
                  controller: _lottieAnimationController,
                  onLoaded: (composite) async {
                    _lottieAnimationController.duration = composite.duration;
                    _textAnimationController.forward();
                    await Future.delayed(const Duration(milliseconds: 250));

                    _lottieAnimationController.forward();
                  },
                ),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _textAnimationController,
                    curve: Curves.easeIn,
                  ),
                  child: Text(
                    "Order Placed Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: SizeConfig.screenWidth! * .045),
                  ),
                ),
                Text(
                  "The order confirmation has been sent to your email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: SizeConfig.screenWidth! * .045),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(
                          SizeConfig.screenHeight! * .015),
                    ),
                    padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("250",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth! * .0375,
                                )),
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * .0315,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("250",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth! * .0375,
                                )),
                            Text(
                              "Items Ordered",
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * .0315,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("250",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth! * .0375,
                                )),
                            Text(
                              "Amount Saved",
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * .0315,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight! * .015),
                  child: CustomElevatedButton(
                      buttonText: "Continue Shopping",
                      onPress: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
