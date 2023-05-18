// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBox extends StatefulWidget {
  final Function(String) onPlaceSelected; // Callback function
  final String googlkey;
  final String hinttext;
  const SearchBox({
    super.key,
    required this.onPlaceSelected,
    required this.googlkey,
    required this.hinttext,
  });

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool isSearchBoxActive = false;
  final _controller = TextEditingController();
  final _results = <String>[];
  Future<void> _searchPlaces(String query, String key) async {
    final encodedQuery = Uri.encodeQueryComponent(
        query); //encodeQueryComponent for make it right formate
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedQuery&key=${key}';
    //url for autocompete search like google

    // 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedQuery&key=$APIKEY';
    //url for places

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['predictions'] as List<dynamic>;
      setState(() {
        _results.clear();
        _results
            .addAll(results.map((result) => result['description'] as String));
      });
    } else {
      throw Exception('Failed to search places');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hinttext,
            border: const OutlineInputBorder(),
          ),
          // ...
          onTap: () {},
          onChanged: (value) {
            if (value.isNotEmpty) {
              // CarServiceIcon.showSnackbar(context, widget.googlkey);

              _searchPlaces(value, widget.googlkey);
            } else {
              setState(() {
                _results.clear();
              });
            }
          },
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_results[index]),
                onTap: () {
                  final selectedPlace = _results[index];
                  widget.onPlaceSelected(
                      selectedPlace); // Call the callback function
                  setState(() {
                    _controller.text = selectedPlace;
                    _results.clear();
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
