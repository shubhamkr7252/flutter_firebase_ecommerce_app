import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/profile/components/custom_confirmation_bottom_sheet.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_loading_indicator.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import '../../widgets/empty_data_widget.dart';
import 'components/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;

  late ScrollController _scrollController;
  late ValueNotifier<bool> _isUserScrolling;

  @override
  void initState() {
    _notificationProvider = Provider.of(context, listen: false);

    _scrollController = ScrollController();
    _isUserScrolling = ValueNotifier<bool>(false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_notificationProvider.isDataLoaded == false) {
        _notificationProvider.fetchNotificationData(userId: widget.userId);
      }
      if (_notificationProvider.isDataLoaded == true &&
          _notificationProvider.allNotificationData.isNotEmpty) {
        Timer.periodic(const Duration(minutes: 1), (_) {
          _notificationProvider.updateNotificationTimeData();
        });
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
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(
          builder: (context, notificationprovider, _) {
        if (notificationprovider.isDataLoaded == true &&
            notificationprovider.allNotificationData.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight! * .015),
            child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                      padding: index == 0
                          ? EdgeInsets.only(
                              top: SizeConfig.screenHeight! * .015)
                          : (index ==
                                  notificationprovider
                                          .allNotificationData.length -
                                      1
                              ? EdgeInsets.only(
                                  bottom: SizeConfig.screenHeight! * .015)
                              : EdgeInsets.zero),
                      child: NotificationTile(
                          notificationData:
                              notificationprovider.allNotificationData[index]),
                    ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: SizeConfig.screenHeight! * .015),
                itemCount: notificationprovider.allNotificationData.length),
          );
        } else if (notificationprovider.isDataLoaded == true &&
            notificationprovider.allNotificationData.isEmpty) {
          return const EmptyDataWidget(
            assetImage: "assets/no_notification.png",
            title: "No new notifications",
            subTitle: "Your notifications will appear here.",
          );
        }
        return const CustomLoadingIndicator(indicatorSize: 20);
      }),
      floatingActionButton: Consumer<NotificationProvider>(
          builder: (context, notificationprovider, _) {
        if (notificationprovider.isDataLoaded == true &&
            notificationprovider.allNotificationData.isNotEmpty) {
          return ValueListenableBuilder(
            valueListenable: _isUserScrolling,
            builder: (context, value, child) => AnimatedSlide(
              offset: value == false
                  ? const Offset(0, 0)
                  : Offset(0, SizeConfig.screenWidth! * .0045),
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.error,
                elevation: 0,
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => CustomConfirmationBottomSheet(
                          title: "Clear Notifications?",
                          buttonColor: Theme.of(context).colorScheme.error,
                          buttonOnTap: () async {
                            await notificationprovider.clearNotification(
                                userId: widget.userId);
                          },
                          buttonText: "Yes"));
                },
                child: Icon(
                  FlutterRemix.delete_bin_2_fill,
                  color: Theme.of(context).colorScheme.background,
                  size: SizeConfig.screenWidth! * .06,
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }
}
