import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_firebase_ecommerce_app/model/order.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RazorpayIntegration {
  var auth = 'Basic ' +
      base64Encode(utf8.encode(
          '${dotenv.env['RAZORPAY_API_ID']}:${dotenv.env['RAZORPAY_API_SECRET']}'));
  Future<OrderIdResponseModel?> getOrderId(
      {required OrderIdRequestModel orderData}) async {
    try {
      var _response = await Dio().post(
        "https://api.razorpay.com/v1/orders/",
        data: orderData,
        options: Options(headers: {'authorization': auth}),
      );

      if (_response.statusCode == 200) {
        return OrderIdResponseModel.fromJson(_response.data);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> makePayment(BuildContext context,
      {required double totalAmount,
      required String orderId,
      required Razorpay razorpay,
      int? timeout,
      String? contact,
      String? email}) async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    try {
      Map<String, dynamic> _options = {
        'key': dotenv.env['RAZORPAY_API_ID'],
        'amount': totalAmount,
        'name': 'Acme Corp.',
        'order_id': orderId,
        'theme': {
          "color": "222222",
        },
        'description': '',
        'timeout': timeout ?? 600,
        'prefill': {
          'contact': contact ?? "9060722872",
          'email': email ?? _userProvider.getCurrentUser!.email,
        }
      };

      razorpay.open(_options);
    } catch (e) {
      log(e.toString());
    }
  }
}
