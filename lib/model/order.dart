import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ecommerce_app/model/product.dart';
import 'package:flutter_firebase_ecommerce_app/model/user_address.dart';

class UserOrderModel {
  List<UserOrderProductObject>? productsOrderInformation;
  RazorpayResponseModel? razorpayPaymentInformation;
  UserAddressObject? address;
  String? uid, orderId;
  Timestamp? orderCreatedAt;
  UserOrderPaymentObject? paymentInformation;

  UserOrderModel({
    this.paymentInformation,
    this.razorpayPaymentInformation,
    this.productsOrderInformation,
    this.address,
    this.uid,
    this.orderCreatedAt,
    this.orderId,
  });

  factory UserOrderModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    List<UserOrderProductObject> getAllProductsAndOrders(List obj) {
      List<UserOrderProductObject> _list = [];
      for (var element in obj) {
        _list.add(UserOrderProductObject.fromJson(element));
      }

      return _list;
    }

    return UserOrderModel(
      uid: data["uid"] ?? "",
      orderId: data["orderId"] ?? "",
      orderCreatedAt: data["orderCreatedAt"] ?? Timestamp.now(),
      address: UserAddressObject.fromJson(data["address"]),
      productsOrderInformation:
          getAllProductsAndOrders(data["productsOrderInformation"]),
      paymentInformation:
          UserOrderPaymentObject.fromJson(data["paymentInformation"]),
      razorpayPaymentInformation:
          RazorpayResponseModel.fromJson(data["razorpayPaymentInformation"]),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    List<Map<String, dynamic>> getAllProductsAndOrders(
        List<UserOrderProductObject> obj) {
      List<Map<String, dynamic>> _list = [];
      for (var element in obj) {
        _list.add(element.toJson());
      }

      return _list;
    }

    data["uid"] = uid;
    data["orderCreatedAt"] = orderCreatedAt;
    data["orderId"] = orderId;
    data["address"] = address!.toJson();
    data["razorpayPaymentInformation"] = razorpayPaymentInformation!.toJson();
    data["paymentInformation"] = paymentInformation!.toJson();
    data["productsOrderInformation"] =
        getAllProductsAndOrders(productsOrderInformation!);

    return data;
  }
}

class UserOrderProductObject {
  ProductListModel? productData;
  UserOrderInformationObject? orderData;

  UserOrderProductObject({
    this.orderData,
    this.productData,
  });

  factory UserOrderProductObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserOrderProductObject(
      orderData: UserOrderInformationObject.fromJson(data["orderData"]),
      productData: ProductListModel.fromJson(data["productData"]),
    );
  }

  toJson() => {
        "productData": productData!.toJson(),
        "orderData": orderData!.toJson(),
      };
}

class UserOrderInformationObject {
  int? status;
  Timestamp? updatedAt;

  UserOrderInformationObject({
    this.status,
    this.updatedAt,
  });

  factory UserOrderInformationObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserOrderInformationObject(
      status: data["status"] ?? "",
      updatedAt: data["updatedAt"],
    );
  }

  toJson() => {
        "status": status,
        "updatedAt": updatedAt,
      };
}

class UserOrderPaymentObject {
  double? totalAmount, delivery, amountPaid, discount;

  UserOrderPaymentObject({
    this.amountPaid,
    this.delivery,
    this.discount,
    this.totalAmount,
  });

  factory UserOrderPaymentObject.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return UserOrderPaymentObject(
        totalAmount: double.parse((data["totalAmount"] ?? 0.0).toString()),
        amountPaid: double.parse((data["amountPaid"] ?? 0.0).toString()),
        discount: double.parse((data["discount"] ?? 0.0).toString()),
        delivery: double.parse((data["delivery"] ?? 0.0).toString()));
  }

  toJson() => {
        "amountPaid": amountPaid,
        "delivery": delivery,
        "discount": discount,
        "totalAmount": totalAmount,
      };
}

class OrderIdRequestModel {
  double? amount;
  String? currency, receipt;

  OrderIdRequestModel({
    this.amount,
    this.currency,
    this.receipt,
  });

  factory OrderIdRequestModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return OrderIdRequestModel(
      amount: double.parse((data["amount"] ?? 0.0).toString()),
      currency: data["currency"] ?? "",
      receipt: data["receipt"] ?? "",
    );
  }

  toJson() => {
        "amount": amount,
        "currency": currency,
        "receipt": receipt,
      };
}

class OrderIdResponseModel {
  String? id, entity, receipt, currency, status;
  int? attempts;
  double? amount, amountPaid, amountDue, createdAt;
  List<String>? notes;

  OrderIdResponseModel({
    this.id,
    this.entity,
    this.receipt,
    this.createdAt,
    this.status,
    this.amount,
    this.amountDue,
    this.amountPaid,
    this.attempts,
    this.notes,
    this.currency,
  });

  factory OrderIdResponseModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);

    return OrderIdResponseModel(
      id: data["id"] ?? "",
      entity: data["entity"] ?? "",
      receipt: data["receipt"] ?? "",
      createdAt: double.parse((data["created_at"] ?? 0.0).toString()),
      status: data["status"] ?? "",
      amount: double.parse((data["amount"] ?? 0.0).toString()),
      amountDue: double.parse((data["amount_due"] ?? 0.0).toString()),
      amountPaid: double.parse((data["amount_paid"] ?? 0.0).toString()),
      attempts: data["attempts"] ?? 0,
      currency: data["currency"] ?? "",
      notes: List.from(data["notes"] ?? []),
    );
  }
}

class RazorpayResponseModel {
  String? paymentId, signature, orderId;

  RazorpayResponseModel({
    this.paymentId,
    this.signature,
    this.orderId,
  });

  factory RazorpayResponseModel.fromJson(var obj) {
    Map<String, dynamic> data = Map<String, dynamic>.from(obj);
    return RazorpayResponseModel(
      paymentId: data["razorpay_payment_id"],
      signature: data["razorpay_signature"],
      orderId: data["razorpay_order_id"],
    );
  }

  toJson() => {
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
        "razorpay_order_id": orderId,
      };
}
