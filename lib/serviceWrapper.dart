// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart ' as http;

class servicewrapper {
// https://androidtutorial.blueappsoftware.com/webapi/razorpay-php-app/orderapi.php

//https://codewithsunil.com/razorpay_php/razorpay-php-testapp-master/orderapi.php/
  static var baseurl =
      "https://codewithsunil.com/razorpay_php/razorpay-php-testapp-master/orderapi.php/";
  static var mainfolder = ""; // "single/";
  static var subfolder = "";
  static var apifolder = "razorpay_php";
  static var mediafolder = "media/";
  static var securitycode = "123";
  callOrderApi(String txnid, String amount) async {
    dynamic jsonresponse = "[]";
    var url = baseurl;
    final body = {'securecode': securitycode, 'txnid': txnid, 'amount': amount};
    // without header
    final response = await http.post(Uri.parse(url), body: body);
    print(' get response done + ${response.body.toString()}');
    try {
      jsonresponse = json.decode(response.body.toString());
    } catch (error) {
      print('get-categrrory error " + ${error.toString()}');
    }
    return jsonresponse;
  }
}
