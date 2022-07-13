import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/screens/my%20address/add_edit_address_screen.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_button_a.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';

class CartTopAddressWidget extends StatelessWidget {
  const CartTopAddressWidget({
    Key? key,
    this.hideButton = false,
  }) : super(key: key);

  final bool hideButton;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartprovider, _) => Container(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        width: SizeConfig.screenWidth!,
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  FlutterRemix.map_pin_2_fill,
                  color: Theme.of(context).colorScheme.primary,
                  size: SizeConfig.screenWidth! * .05,
                ),
                SizedBox(width: SizeConfig.screenWidth! * .02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Deliver to: ${cartprovider.getCartDeliveryAddress!.pinCode}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.screenWidth! * .04,
                          fontFamily: "Poppins"),
                    ),
                    if (hideButton == false)
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: SizeConfig.screenWidth! * .0325,
                              fontFamily: "Poppins"),
                          children: [
                            TextSpan(
                              text:
                                  (cartprovider.getCartDeliveryAddress!.name! +
                                          ", " +
                                          cartprovider.getCartDeliveryAddress!
                                              .addressLine1! +
                                          ", " +
                                          cartprovider.getCartDeliveryAddress!
                                              .addressLine2!)
                                      .substring(
                                          0,
                                          cartprovider.getCartDeliveryAddress!
                                                          .name!.length +
                                                      cartprovider
                                                          .getCartDeliveryAddress!
                                                          .addressLine1!
                                                          .length +
                                                      cartprovider
                                                          .getCartDeliveryAddress!
                                                          .addressLine2!
                                                          .length <
                                                  22
                                              ? cartprovider
                                                      .getCartDeliveryAddress!
                                                      .name!
                                                      .length +
                                                  cartprovider
                                                      .getCartDeliveryAddress!
                                                      .addressLine1!
                                                      .length +
                                                  cartprovider
                                                      .getCartDeliveryAddress!
                                                      .addressLine2!
                                                      .length
                                              : 22),
                            ),
                            if (cartprovider
                                        .getCartDeliveryAddress!.name!.length +
                                    cartprovider.getCartDeliveryAddress!
                                        .addressLine1!.length +
                                    cartprovider.getCartDeliveryAddress!
                                        .addressLine2!.length >
                                22)
                              const TextSpan(text: ".....")
                          ],
                        ),
                      ),
                    if (hideButton == true)
                      SizedBox(
                        width: SizeConfig.screenWidth! / 1.275,
                        child: Text(
                          cartprovider.getCartDeliveryAddress!.name! +
                              ", " +
                              cartprovider
                                  .getCartDeliveryAddress!.addressLine1! +
                              ", " +
                              cartprovider
                                  .getCartDeliveryAddress!.addressLine2!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: SizeConfig.screenWidth! * .0325,
                            fontFamily: "Poppins",
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
            if (hideButton == false)
              SizedBox(width: SizeConfig.screenWidth! * .025),
            if (hideButton == false)
              Flexible(
                child: CustomButtonA(
                  width: SizeConfig.screenWidth! * .25,
                  buttonText: "Change",
                  onPress: () async {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      isScrollControlled: true,
                      builder: (context) => CartAddressSelectionBottomSheet(
                        defaultCartAddressId:
                            cartprovider.getCartDeliveryAddress!.addressId!,
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CartAddressSelectionBottomSheet extends StatefulWidget {
  const CartAddressSelectionBottomSheet({
    Key? key,
    required this.defaultCartAddressId,
  }) : super(key: key);

  final String defaultCartAddressId;

  @override
  State<CartAddressSelectionBottomSheet> createState() =>
      _CartAddressSelectionBottomSheetState();
}

class _CartAddressSelectionBottomSheetState
    extends State<CartAddressSelectionBottomSheet> {
  late UserAddressesProvider _userAddressesProvider;

  @override
  void initState() {
    _userAddressesProvider = Provider.of(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBottomSheetDragHandleWithTitle(
                title: "Select Delivery Address"),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.screenHeight! * .015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<CartProvider>(
                    builder: (context, cartprovider, _) =>
                        Consumer<UserAddressesProvider>(
                            builder: (context, addressproivder, _) {
                      if (addressproivder.isDataLoaded == true &&
                          addressproivder
                              .allAddressesData!.addresses!.isNotEmpty) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                  addressproivder.allAddressesData!.addresses!
                                      .length, (index) {
                                return Padding(
                                  padding: index == 0
                                      ? EdgeInsets.only(
                                          left: SizeConfig.screenHeight! * .015,
                                          right:
                                              SizeConfig.screenHeight! * .015)
                                      : EdgeInsets.only(
                                          right:
                                              SizeConfig.screenHeight! * .015),
                                  child: CartAddressTile(
                                    addressData: addressproivder
                                        .allAddressesData!.addresses![index],
                                    isDefault: addressproivder.allAddressesData!
                                            .addresses![index].addressId ==
                                        cartprovider
                                            .getCartDeliveryAddress!.addressId,
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      } else if (addressproivder.isDataLoaded == true &&
                          addressproivder
                              .allAddressesData!.addresses!.isNotEmpty) {
                        return const SizedBox();
                      }
                      return const CustomLoadingIndicator(indicatorSize: 20);
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.screenHeight! * .015,
                  0.0,
                  SizeConfig.screenHeight! * .015,
                  SizeConfig.screenHeight! * .015),
              child: CustomButtonA(
                  buttonText: "Add New Address",
                  onPress: () {
                    NavigatorService.push(context,
                        page: AddEditAddressScreen(
                            index: _userAddressesProvider
                                    .allAddressesData!.addresses!.length +
                                1));
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CartAddressTile extends StatelessWidget {
  const CartAddressTile(
      {Key? key, required this.addressData, required this.isDefault})
      : super(key: key);

  final UserAddressObject addressData;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartprovider, _) => InkWell(
        onTap: () async {
          await cartprovider.setCartDeliveryAddress(addressData);
          Navigator.of(context).pop();
        },
        child: Container(
          width: SizeConfig.screenWidth! * .575,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          ),
          padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      addressData.title!,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: SizeConfig.screenWidth! * .0375,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isDefault == true)
                    SizedBox(width: SizeConfig.screenHeight! * .015),
                  if (isDefault == true)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.screenWidth! * .01),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.screenWidth! * .01),
                        child: Icon(
                          FlutterRemix.check_fill,
                          color: Theme.of(context).colorScheme.background,
                          size: SizeConfig.screenWidth! * .04,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Text(
                addressData.name!,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
              ),
              Text(
                addressData.phone!,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
              ),
              Text(
                addressData.email!,
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
              ),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Text(
                addressData.addressLine1! +
                    "," +
                    addressData.addressLine2! +
                    "," +
                    addressData.city! +
                    "," +
                    addressData.state! +
                    ",",
                style: TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Text(
                "Pin Code: " + addressData.pinCode!,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * .035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
