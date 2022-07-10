import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  String? paymentId, orderId;

  RazorpayResponseModel({
    this.orderId,
    this.paymentId,
  });

  factory RazorpayResponseModel.fromJson(PaymentSuccessResponse obj) {
    return RazorpayResponseModel(
      paymentId: obj.paymentId,
      orderId: obj.orderId,
    );
  }

  toJson() => {
        "razorpay_payment_id": paymentId,
        "razorpay_order_id": orderId,
      };
}
