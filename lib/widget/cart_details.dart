import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider_star/star_count.dart';
import '../ratingbar/rating_bar.dart';
import 'adding_cart.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      width: 53.w,
      margin: EdgeInsets.only(top: 1.h, bottom: 1.h, right: 1.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 44.w,
              height: 5.h,
              margin: EdgeInsets.fromLTRB(3.w, 2.h, 1.w, 0.h),
              child: Text(
                'MERIDTH',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 44.w,
              height: 3.h,
              margin: EdgeInsets.fromLTRB(3.w, 0.h, 1.w, 0.h),
              child: Text(
                'Descriptions',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: 44.w,
              height: 7.h,
              margin: EdgeInsets.fromLTRB(1.w, 0.h, 1.w, 0.h),
              child: Consumer<StarCountProvider>(
                builder: (context, provider, child) {
                  debugPrint('main pass value--> ${provider.getstarcount}');
                  return RatingBar(
                    starCount: 5,
                    rating: provider.getstarcount,
                  );
                },
              ),
            ),
            AddingCart(),
            SizedBox(
              height: 7.h,
              width: 53.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.track_changes, size: 12.sp),
                      Text(
                        "Shipping",
                        style: TextStyle(fontSize: 8.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.track_changes, size: 12.sp),
                      Text(
                        "Evaluate",
                        style: TextStyle(fontSize: 8.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.track_changes, size: 12.sp),
                      Text(
                        "Return",
                        style: TextStyle(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
