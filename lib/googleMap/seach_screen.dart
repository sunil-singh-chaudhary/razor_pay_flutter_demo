import 'package:flutter/material.dart';

import 'search_box.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchBox(
              onPlaceSelected: (p0) {
                debugPrint("source $p0");
              },
            ),
          ),
          Positioned(
            top: 60, // Adjust the position as needed
            left: 0,
            right: 0,
            child: SearchBox(
              onPlaceSelected: (p0) {
                debugPrint("destination $p0");
              },
            ),
          ),
        ],
      ),
    );
  }
}
