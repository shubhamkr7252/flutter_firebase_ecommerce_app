import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/provider/order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20order/components/my_order_tile.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20order/my_order_details_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/empty_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late OrderProvider _OrderProvider;

  @override
  void initState() {
    _OrderProvider = Provider.of(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_OrderProvider.isDataLoaded == false) {
        _OrderProvider.fetchOrdersData(userId: widget.userId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "My Orders",
      body: Consumer<OrderProvider>(builder: (context, orderprovider, _) {
        if (orderprovider.isDataLoaded == true &&
            orderprovider.allOrdersData.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) => Padding(
                      padding: index == 0
                          ? EdgeInsets.only(
                              top: SizeConfig.screenHeight! * .015)
                          : (index == orderprovider.allOrdersData.length - 1
                              ? EdgeInsets.only(
                                  bottom: SizeConfig.screenHeight! * .015)
                              : EdgeInsets.zero),
                      child: MyOrderTile(
                        orderData: orderprovider.allOrdersData[index],
                        onTap: () {
                          NavigatorService.push(context,
                              page: MyOrderDetailsScreen(
                                  orderData:
                                      orderprovider.allOrdersData[index]));
                        },
                      ),
                    ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                itemCount: orderprovider.allOrdersData.length),
          );
        } else if (orderprovider.allOrdersData.isEmpty &&
            orderprovider.isDataLoaded == true) {
          return const EmptyDataWidget(
            assetImage: "assets/order.png",
            title: "No orders found",
            subTitle: "Your placed orders will appear here.",
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
