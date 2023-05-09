import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider_star/star_count.dart';

class RatingBar extends StatelessWidget {
  final int starCount;
  final int rating;
  RatingBar({this.starCount = 5, this.rating = 0});

  @override
  Widget build(BuildContext context) {
    final providers = context.watch<StarCountProvider>();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: starCount,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 4.h,
          width: 8.w,
          child: GestureDetector(
            onTap: () {
              if (rating == index + 1) {
                debugPrint('click equal--> ${starCount - index}');

                // if the user taps the same star that was already selected, deselect it
                providers.updateStarCount(index);
              } else {
                debugPrint('click increase--> ${index + 1}');

                // update the rating and star count
                providers.updateStarCount(index + 1);
              }
            },
            child: Icon(
              index < providers.getstarcount ? Icons.star : Icons.star_border,
              color: index < providers.getstarcount
                  ? Colors.orange
                  : Colors.black87,
            ),
          ),
        );
      },
    );
  }
}
