import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "My Orders",
      body: Consumer<UserOrderProvider>(
          builder: (context, useraddressprovider, _) {
        if (useraddressprovider.isDataLoaded == true &&
            useraddressprovider.allAddressesData != null) {
          return Container();
        } else if (useraddressprovider.allAddressesData == null &&
            useraddressprovider.isDataLoaded == true) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/order.png",
                    width: SizeConfig.screenWidth! * .4,
                    color:
                        Theme.of(context).colorScheme.secondary.withAlpha(150)),
                SizedBox(height: SizeConfig.screenWidth! * .02),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth! * .1),
                  child: Column(
                    children: [
                      Text(
                        "No orders found",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth! * .045),
                      ),
                      SizedBox(height: SizeConfig.screenWidth! * .01),
                      Opacity(
                          opacity: 0.75,
                          child: Text(
                            "Your placed orders will appear here.",
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * .036),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .03),
          child: CustomLoadingIndicator(
              indicatorSize: SizeConfig.screenHeight! * .025),
        );
      }),
    );
  }
}
