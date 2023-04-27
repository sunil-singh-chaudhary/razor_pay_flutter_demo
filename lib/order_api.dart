// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'modelorderId.dart';
import 'payment_model.dart';
import 'serviceWrapper.dart';

class OrderApi {
  getorderId(String txnid, PaymentModel formMap, Razorpay razorpay) async {
    servicewrapper wrapper = servicewrapper();
    Map<String, dynamic> response =
        await wrapper.callOrderApi(txnid, formMap.amount!);
    final model = ModelOrderId.fromJson(response);
    print('response here');
    if (model.status == 1) {
      if (kDebugMode) {
        print(" order id is - ${model.information}");
        print(" transaction id is - $txnid");
      }
      _startPayment(model.information.toString(), formMap, razorpay);
    } else {
      print("status zero");
    }
  }

  _startPayment(String orderid, PaymentModel formMap, Razorpay razorpay) async {
    var options = {
      'key': formMap.key,
      'amount': formMap.amount,
      'order_id': orderid,
      'name': formMap.name,
      'description': formMap.description,
      'prefill': {
        'contact': formMap.prefill!.contact,
        'email': formMap.prefill!.email
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }
}
