import 'dart:convert';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CarServiceIcon {
  static Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<LatLng> convertAddressToLatLng(String address) async {
    try {
      List<Location> locations = await geocoding.locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      print('Error converting address to LatLng: $e');
    }
    return LatLng(0, 0); // Default coordinates if conversion fails
  }

  Future<void> searchPlaces(String apiKey, String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Process the search results
      if (data['status'] == 'OK') {
        final results = data['results'];

        for (var result in results) {
          final name = result['name'];
          final location = result['geometry']['location'];
          final latitude = location['lat'];
          final longitude = location['lng'];

          // Use the retrieved data for further processing
          print('Name: $name');
          print('Latitude: $latitude');
          print('Longitude: $longitude');
        }
      } else {
        print('Error: ${data['status']}');
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }
}
