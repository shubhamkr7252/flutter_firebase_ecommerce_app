import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/service/auth_service.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom%20loader/custom_loader.dart';
import '../../theme/size.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<void>(
      future: AuthService.init(context),
      builder: (context, snapshot) {
        return const SplashLoader();
      },
    );
  }
}

class SplashLoader extends StatelessWidget {
  const SplashLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.background,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Container(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.background,
          child: Stack(
            children: [
              SizedBox(
                width: SizeConfig.screenWidth!,
                height: SizeConfig.screenHeight!,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/logo_outline.png",
                    width: SizeConfig.screenHeight! * .125,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.screenHeight! * .15),
                    child: SizedBox(
                      height: SizeConfig.screenWidth! * .1,
                      width: SizeConfig.screenWidth! * .1,
                      child: CustomLoader(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary,
                        size: SizeConfig.screenWidth! * .1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
