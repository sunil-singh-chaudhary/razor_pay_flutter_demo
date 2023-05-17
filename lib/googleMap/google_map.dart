// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:razor_pay_flutter_demo/googleMap/location_provider.dart';
import 'package:razor_pay_flutter_demo/googleMap/seach_screen.dart';
import 'package:razor_pay_flutter_demo/googleMap/search_box.dart';
import 'package:sizer/sizer.dart';

import 'car_service.dart';

LatLng source = const LatLng(28.6545, 77.3677);
LatLng destination = const LatLng(28.6394, 77.3109);
List<LatLng> polylinecordinates = [];
LocationData? currentlocation;
Marker? marker;

Circle? circle;
// ignore: constant_identifier_names
const APIKEY = "AIzaSyCWGF51tjIgdaMQ1wyY4GlBRKddH0O8VA8";

Completer<GoogleMapController> mapcontroller = Completer();

// ignore: must_be_immutable
class GoogleMapDemo extends StatefulWidget {
  GoogleMapDemo({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  double? latitude;
  double? longitude;
  StreamSubscription<LocationData>? locationSubscription;
  final Map<String, Marker> _markerMap = {};
  Uint8List? imageData;
  final source_controller = TextEditingController();
  final destination_controller = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  State<GoogleMapDemo> createState() => _GoogleMapDemoState();
}

class _GoogleMapDemoState extends State<GoogleMapDemo> {
  Location location = Location();

  @override
  void initState() {
    //checkPermission();
    super.initState();
    getLocation();
    getPolyPoints();
  }

  @override
  void dispose() {
    widget.locationSubscription!.cancel();
    super.dispose();
  }

  static CameraPosition initialLocation = CameraPosition(
    target: source,
    zoom: 14,
  );

  void getLocation() async {
    widget.imageData = await CarServiceIcon.getMarker(context);
    try {
      // await location.changeSettings(interval: 60000);
      currentlocation = await location.getLocation();

      if (widget.locationSubscription != null) {
        widget.locationSubscription!.cancel();
      }
      widget.locationSubscription =
          location.onLocationChanged.listen((newLocalData) {
        debugPrint("GetLocation--> $newLocalData");

        updateaddMarker('currentposition', newLocalData, "Current Position",
            widget.imageData!);

        animateCameraToLocation(
            LatLng(newLocalData.latitude!, newLocalData.longitude!),
            mapcontroller);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    setState(() {});
  }

//animate camera to the Udpated position with new location and controller
  void animateCameraToLocation(
      LatLng target, Completer<GoogleMapController> currentLocation) async {
    final GoogleMapController controller = await currentLocation.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: target,
        tilt: 0,
        zoom: 14,
      )),
    );
  }

  //  Show line betwenn two final and start positions
  void getPolyPoints() async {
    debugPrint('start polypoints');
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    debugPrint(result.errorMessage);

    if (result.points.isNotEmpty) {
      for (var everyPoint in result.points) {
        debugPrint('adding-->${result.points}');
        polylinecordinates
            .add(LatLng(everyPoint.latitude, everyPoint.longitude));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> mapController = Completer();
    Provider.of<LocationProvider>(context).initialization();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: TextField(
          focusNode: widget.searchFocusNode,
          controller: widget.source_controller,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
      ),
      body: GoogelMapUI(mapController),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_searching),
          onPressed: () {
            debugPrint("Clicked");
            //add pubspec.yml geocoding for converting loation name to lat lng
            //add pubspec.yml flutter_google_places for powerful google map search
            // String source = widget.source_controller.text;

            //await CarServiceIcon().searchPlaces(APIKEY, source);

            // getLocation();
            // getPolyPoints();
          }),
    );
  }

  void updateaddMarker(
      String id, LocationData loc, String msg, Uint8List imageData) {
    var latlong = LatLng(loc.latitude!, loc.longitude!);

    setState(() {
      marker = Marker(
        markerId: MarkerId(id),
        position: latlong,
        rotation: loc.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        icon: BitmapDescriptor.fromBytes(imageData),
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: 'here Add first',
          snippet: msg,
        ),
      );

      circle = Circle(
          circleId: const CircleId("car"),
          radius: loc.accuracy!,
          zIndex: 1,
          strokeColor: Colors.green,
          center: latlong,
          fillColor: Colors.blue.withAlpha(70));
    });
    widget._markerMap[id] = marker!;
  }

// add icon in destination
  void addMarkeDestination(String id, LocationData loc, String msg) {
    var latlong = LatLng(loc.latitude!, loc.longitude!);
    marker = Marker(
      markerId: MarkerId(id),
      position: latlong,
      draggable: false,
      infoWindow: InfoWindow(
        title: 'here Add first',
        snippet: msg,
      ),
    );

    widget._markerMap[id] = marker!;
  }

  Widget GoogelMapUI(Completer<GoogleMapController> mapController) {
    return currentlocation != null
        ? GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: initialLocation,
            // markers: Set.of((marker != null) ? [marker!] : [])..add(destinationMarker),,
            // circles: Set.of((circle != null) ? [circle!] : []),
            onMapCreated: (controller) {
              mapController.complete(controller);

              addMarkeDestination(
                'source',
                LocationData.fromMap({
                  "latitude": source.latitude,
                  "longitude": source.longitude,
                }),
                "source Position",
              );

              addMarkeDestination(
                'destinations',
                LocationData.fromMap({
                  "latitude": destination.latitude,
                  "longitude": destination.longitude,
                }),
                "Destination Position",
              );
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('routes'),
                points: polylinecordinates,
                color: Colors.blue,
                width: 7,
              )
            },
            //important to show default icon dont remove it
            markers: widget._markerMap.values.toSet(),
            // circles: widget.,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
