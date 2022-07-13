import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:jiffy/jiffy.dart';
import '../../../model/notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key, required this.notificationData})
      : super(key: key);

  final NotificationModel notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01)),
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notificationData.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.screenWidth! * .0375),
                    ),
                    Text(
                      notificationData.description!,
                      style:
                          TextStyle(fontSize: SizeConfig.screenWidth! * .0325),
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth! * .045),
              Container(
                width: SizeConfig.screenWidth! * .15,
                height: SizeConfig.screenWidth! * .15,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.screenHeight! * .005),
                  child: GridView.count(
                    crossAxisCount:
                        notificationData.images!.length == 1 ? 1 : 2,
                    children: notificationData.images!
                        .map((e) => CachedNetworkImage(
                              imageUrl: e,
                              fit: BoxFit.contain,
                              width: SizeConfig.screenHeight! * .015,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * .015),
          Text(
            Jiffy(notificationData.createdAt!.toDate()).fromNow(),
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }
}
