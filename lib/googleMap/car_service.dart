import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  static Future<Map<String, double>> getLatLngFromAddress(
      String address, String apiKey) async {
    final encodedAddress = Uri.encodeQueryComponent(address);
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          final lat = location['lat'] as double;
          final lng = location['lng'] as double;
          return {'latitude': lat, 'longitude': lng};
        }
      }
    }

    throw Exception('Failed to get latitude and longitude for the address');
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
          debugPrint('Name: $name');
          debugPrint('Latitude: $latitude');
          debugPrint('Longitude: $longitude');
        }
      } else {
        debugPrint('Error: ${data['status']}');
      }
    } else {
      debugPrint('HTTP request failed with status: ${response.statusCode}');
    }
  }

  static Future<String> getApiKey() async {
    // loading googlekey from .env
    await dotenv.load();
    var googlemapKey = dotenv.env['GOOGLE_APIKEY'];
    return googlemapKey!;
  }

  static void showSnackbar(BuildContext context, String key) {
    final snackBar = SnackBar(
      content: Text(key),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Perform an action when the "Close" button is pressed
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
