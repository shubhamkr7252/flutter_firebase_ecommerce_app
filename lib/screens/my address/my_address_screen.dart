import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/empty_data_widget.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address/add_edit_address_screen.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address/components/address_tile.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_scaffold.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  late UserAddressesProvider _addressesProvider;

  late ScrollController _scrollController;

  late ValueNotifier<bool> _isUserScrolling;

  @override
  void initState() {
    _isUserScrolling = ValueNotifier<bool>(false);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isUserScrolling.value == false) {
          _isUserScrolling.value = true;
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isUserScrolling.value == true) {
            _isUserScrolling.value = false;
          }
        }
      }
    });

    _addressesProvider =
        Provider.of<UserAddressesProvider>(context, listen: false);

    if (_addressesProvider.isDataLoaded == false) {
      _addressesProvider.fetchAddressesData(context, userId: widget.userId);
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isUserScrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "My Addresses",
      body: Consumer<UserAddressesProvider>(
          builder: (context, useraddressprovider, _) {
        if (useraddressprovider.isDataLoaded == true &&
            useraddressprovider.allAddressesData != null &&
            useraddressprovider.allAddressesData!.addresses!.isNotEmpty) {
          return ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                    padding: index == 0
                        ? EdgeInsets.only(top: SizeConfig.screenHeight! * .015)
                        : (index ==
                                useraddressprovider
                                        .allAddressesData!.addresses!.length -
                                    1
                            ? EdgeInsets.only(
                                bottom: SizeConfig.screenHeight! * .015)
                            : EdgeInsets.zero),
                    child: AddressTile(
                      data: useraddressprovider
                          .allAddressesData!.addresses![index],
                      isDefault: useraddressprovider
                              .allAddressesData!.addresses![index].addressId ==
                          useraddressprovider.getDefaultAddressData!.addressId,
                      index: index,
                    ),
                  ),
              separatorBuilder: (context, index) =>
                  SizedBox(height: SizeConfig.screenHeight! * .015),
              itemCount:
                  useraddressprovider.allAddressesData!.addresses!.length);
        } else if (useraddressprovider.allAddressesData != null &&
            useraddressprovider.isDataLoaded == true &&
            useraddressprovider.allAddressesData!.addresses!.isEmpty) {
          return const EmptyDataWidget(
            assetImage: "assets/location.png",
            title: "No address found",
            subTitle: "Click on the '+' icon to add an address.",
          );
        }
        return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: SizeConfig.screenHeight! * .03),
          child: CustomLoadingIndicator(
              indicatorSize: SizeConfig.screenHeight! * .025),
        );
      }),
      fab: ValueListenableBuilder(
        valueListenable: _isUserScrolling,
        builder: (context, value, child) => AnimatedSlide(
          offset: value == false
              ? const Offset(0, 0)
              : Offset(0, SizeConfig.screenWidth! * .0045),
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: () {
              NavigatorService.push(context,
                  page: AddEditAddressScreen(
                    index:
                        _addressesProvider.allAddressesData!.addresses!.length +
                            1,
                  ));
            },
            child: Icon(
              FlutterRemix.add_fill,
              color: Theme.of(context).colorScheme.background,
              size: SizeConfig.screenWidth! * .06,
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
