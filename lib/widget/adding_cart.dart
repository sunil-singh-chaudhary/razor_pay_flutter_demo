import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider_star/star_count.dart';

class AddingCart extends StatelessWidget {
  const AddingCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providers = context.watch<StarCountProvider>();
    return Container(
      width: 44.w,
      height: 7.h,
      margin: EdgeInsets.fromLTRB(2.w, 0.h, 1.w, 0.h),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 7.h,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(2.w, 0.h, 2.w, 1.h),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => providers.removeQuantity(),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
                Consumer<StarCountProvider>(
                  builder: (context, value, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      value.gettotalquantity.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => providers.addQuantity(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
            height: 7.h,
            child: const Text(''),
          )
        ],
      ),
    );
  }
}
