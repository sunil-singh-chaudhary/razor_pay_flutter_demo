import 'package:flutter/material.dart';
import 'search_box.dart';

class SearchScreen extends StatefulWidget {
  final String googlekey;
  // final Function(String) sourceCallback;
  // final Function(String) destinationCallback;
  const SearchScreen({
    super.key,
    required this.googlekey,
    // required this.sourceCallback,
    // required this.destinationCallback,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? sourceAddress;
  String? destinationAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Perform any desired actions or return data here
          var source = sourceAddress;
          var dest = destinationAddress;

          // Pass the data back to the previous screen
          Navigator.of(context).pop([source, dest]);

          // Return true to allow the back navigation
          return true;
        },
        child: Stack(
          children: [
            Positioned(
              top: 60, // Adjust the position as needed
              left: 0,
              right: 0,
              child: SearchBox(
                hinttext: "Search Start Position",
                googlkey: widget.googlekey,
                onPlaceSelected: (p0) {
                  debugPrint("destination $p0");
                  sourceAddress = p0;
                  setState(() {});
                  // widget.sourceCallback(p0);
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SearchBox(
                hinttext: "Search Destination",
                googlkey: widget.googlekey,
                onPlaceSelected: (p0) {
                  debugPrint("source $p0");
                  destinationAddress = p0;
                  setState(() {});

                  // widget.destinationCallback(p0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
