// ignore_for_file: avoid_print

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:flutter/material.dart';

import '../payment_feature/order_api.dart';
import '../payment_feature/payment_model.dart';

class RazorpayApi {
  RazorpayApi(
      {required BuildContext context,
      required PaymentModel formMap,
      required this.responseCallback,
      required this.failedCallback,
      required this.walletCallback}) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _orderapi.getorderId(
        '1234455', formMap, _razorpay); //transxid generate unique every time
  }

  final _razorpay = Razorpay();
  final _orderapi = OrderApi();
  Function(PaymentSuccessResponse)? responseCallback;
  Function(PaymentFailureResponse)? failedCallback;
  Function(ExternalWalletResponse)? walletCallback;

  void refundPayment(String paymentId, double amount) async {
    try {
      // var response =
      //     await _razorpay.refund(paymentId, amount.toInt() * 100);
      // print(response);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    responseCallback?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    failedCallback?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    walletCallback?.call(response); //call method call when it is not null
    //You can also do it by if(reponse !=null {walletcallback(response)})
  }

  void dispose() {
    _razorpay.clear();
  }
}
