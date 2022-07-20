import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OnesignalNotificationService {
  Future<void> sendNotification({
    required String title,
    required String content,
    required List<String> tokenIds,
  }) async {
    try {
      await Dio().post(
        "https://onesignal.com/api/v1/notifications",
        options: Options(
          headers: {
            "Authorization": "Basic ${dotenv.env["ONESIGNAL_API_KEY"]}"
          },
        ),
        data: {
          "app_id": dotenv.env["ONESIGNAL_APP_ID"]!,
          "include_player_ids": tokenIds,
          "headings": {"en": title},
          "contents": {"en": content},
          "small_icon": "ic_stat_onesignal_default",
          "android_channel_id": "0f5a4dd9-812a-48c3-b937-83efe9f0d284"
        },
      );
    } on DioError catch (e) {
      log(e.toString());
    }
  }
}
