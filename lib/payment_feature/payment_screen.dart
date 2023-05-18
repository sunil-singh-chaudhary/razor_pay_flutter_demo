// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Database/database_helper.dart';
import '../payment_services/razor_pay_api.dart';
import '../provider_star/star_count.dart';
import '../radioModel/my_radio.dart';
import '../widget/cart_details.dart';
import 'payment_model.dart';

final dbHelper = DBHelper();

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key, required this.formMap}) : super(key: key);

  PaymentModel formMap;
  String? orderID;
  String? paymentID;

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late RazorpayApi _razorpayService;

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final counterProvider = context.watch<StarCountProvider>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 54.h,
            width: 100.w,
            decoration: const BoxDecoration(color: Color(0xFFf5f6fa)),
            child: Stack(
              children: [
                Positioned(
                  top: -5.h,
                  right: -30.h,
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.h)),
                      color: const Color(0xFFf9e548),
                    ),
                  ),
                ),
                Positioned(
                  top: -48.w,
                  left: -48.w,
                  child: Container(
                    height: 150.w,
                    width: 150.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.w)),
                      color: const Color(0xFF09e492),
                    ),
                  ),
                ),
                Positioned(
                  top: -25.w,
                  left: -20.w,
                  child: Container(
                    height: 80.w,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.w)),
                      color: const Color(0xFFf5f6fa),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    automaticallyImplyLeading:
                        false, // hides the default back button
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // define the height of the AppBar here
                    // based on your preference
                    // this example uses a height of 60
                    toolbarHeight: 60,
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 1.h,
                  child: SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: Image.asset('assets/images/result.png'),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                height: 34.h,
                width: 100.w,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  //BOX DETAILS
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Container(
                            height: 20.h,
                            width: 20.w,
                            margin: EdgeInsets.only(top: 1.h),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: MyRadioButtonGroup(),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                            margin: EdgeInsets.all(1.h),
                            height: 10.h,
                            width: 20.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFffe309),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Consumer<StarCountProvider>(
                              builder: (context, value, child) => Center(
                                  child: Text(
                                (value.gettotalquantity * 12).toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                    const CartDetails(),
                  ],
                ),
              ),
              Positioned(
                top: 1.h,
                right: 10.w,
                child: Container(
                  height: 10.h,
                  width: 10.w,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  child: const Icon(
                    Icons.heart_broken_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 6.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: ElevatedButton.icon(
                onPressed: () {
                  _razorpayService = RazorpayApi(
                      context: context,
                      formMap: widget.formMap,
                      responseCallback: (response) {
                        //insert succes data into Database
                        insertDatabaseData(response);
                      },
                      failedCallback: (failresponse) {
                        print(failresponse.message);
                      },
                      walletCallback: (walletresponse) {
                        print(walletresponse.walletName);
                      });
                },
                icon: const Icon(Icons.add),
                label: const Text('Purchase')),
          ),
        ],
      ),
    );
  }

  void insertDatabaseData(PaymentSuccessResponse response) async {
    await dbHelper.insertData(
        orderId: response.orderId!,
        paymentId: response.paymentId!,
        orderDetails: widget.formMap.description!,
        numberofOrder: 1,
        orderPrice: double.parse(widget.formMap.amount!),
        totalPrice: double.parse(widget.formMap.amount!) * 2);
  }
}
