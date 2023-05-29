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

import 'car_service.dart';

LatLng source = const LatLng(0, 0);
LatLng destination = const LatLng(0, 0);
List<LatLng> polylinecordinates = [];
LocationData? currentlocation;
Marker? marker;
List? backPressData;
Circle? circle;
// ignore: constant_identifier_names

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
  final Map<String, Circle> _circleMap = {};
  Uint8List? imageData;
  final sourceController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String? googlekey;
  @override
  State<GoogleMapDemo> createState() => _GoogleMapDemoState();
}

class _GoogleMapDemoState extends State<GoogleMapDemo> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
    loadCarImage();
    initializeApiKey();
  }

  void loadCarImage() async {
    widget.imageData = await CarServiceIcon.getMarker(context);
  }

  @override
  void dispose() {
    widget.locationSubscription!.cancel();
    super.dispose();
  }

  static CameraPosition initialLocation = CameraPosition(
    target: source,
    zoom: 5, // 5 means less zoom increase 5 will increase zoom
  );

  void getLocation() async {
    try {
      // await location.changeSettings(interval: 60000);
      currentlocation = await location.getLocation();

      if (widget.locationSubscription != null) {
        widget.locationSubscription!.cancel();
      }
      widget.locationSubscription =
          location.onLocationChanged.listen((newLocalData) {
        debugPrint("currentLocation--> $newLocalData");

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
    addMarkeDestination(
      'source',
      LocationData.fromMap({
        "latitude": source.latitude,
        "longitude": source.longitude,
      }),
      "source Position",
    );
    animateCameraToMove(
        LatLng(source.latitude, source.longitude), mapcontroller);

    addMarkeDestination(
      'destinations',
      LocationData.fromMap({
        "latitude": destination.latitude,
        "longitude": destination.longitude,
      }),
      "Destination Position",
    );
    setState(() {});
  }

//animate camera to the Udpated position with new location and controller
  void animateCameraToLocation(
      LatLng target, Completer<GoogleMapController> currentLocation) async {
    final GoogleMapController controller = await currentLocation.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.232340,
        target: target,
        tilt: 0,
        zoom: 20,
      )),
    );
  }

  void animateCameraToMove(
      LatLng target, Completer<GoogleMapController> currentLocation) async {
    final GoogleMapController controller = await currentLocation.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.232340,
        target: target,
        tilt: 0,
        zoom: 20,
      )),
    );
  }

  //  Show line betwenn two final and start positions
  void getPolyPoints() async {
    // CarServiceIcon.showSnackbar(context, widget.googlekey!);
    debugPrint('start polypoints');

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      widget.googlekey!,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    debugPrint(result.errorMessage);
    polylinecordinates.clear();
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
          controller: widget.sourceController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onTap: () {
            final currentContext = context;
            Future<void>.microtask(() async {
              final result = await Navigator.push(
                currentContext,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    googlekey: widget.googlekey!,
                  ),
                ),
              );
              setState(() {
                backPressData = result;
              });
              // CarServiceIcon.showSnackbar(currentContext, result);
            });
          },
        ),
      ),
      body: googelMapUI(mapController),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_searching),
          onPressed: () async {
            var sourcebak = backPressData![0];
            var destinationback = backPressData![1];
            try {
              final srclatLng = await CarServiceIcon.getLatLngFromAddress(
                  sourcebak, widget.googlekey!);
              final srclatitude = srclatLng['latitude'];
              final srclongitude = srclatLng['longitude'];
              final destlatLng = await CarServiceIcon.getLatLngFromAddress(
                  destinationback, widget.googlekey!);
              final destlatitude = destlatLng['latitude'];
              final destlongitude = destlatLng['longitude'];
              setState(() {
                source = LatLng(srclatitude!, srclongitude!);
                destination = LatLng(destlatitude!, destlongitude!);
              });
            } catch (e) {
              debugPrint('Error: $e');
            }
            getLocation();
            getPolyPoints();
          }),
    );
  }

  void updateaddMarker(
      String id, LocationData loc, String msg, Uint8List imageData) {
    var latlong = LatLng(loc.latitude!, loc.longitude!);

    setState(() {
      //remove old marker or circle and add new when updated map
      if (id == 'source') {
        // Remove the old source marker
        if (widget._markerMap.containsKey('source')) {
          widget._markerMap.remove('source');
        }
      } else {
        // Remove any other markers (if needed)
        // widget._markerMap.clear();
      }
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
    widget._circleMap[id] = circle!;
  }

// add icon in destination
  void addMarkeDestination(String id, LocationData loc, String msg) {
    var latlong = LatLng(loc.latitude!, loc.longitude!);
    //clear old markon map
    // widget._markerMap.clear();

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
    setState(() {});
  }

  Widget googelMapUI(Completer<GoogleMapController> mapController) {
    return currentlocation != null
        ? GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: initialLocation,

            onMapCreated: (controller) {
              mapController.complete(controller);
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
            circles: widget._circleMap.values.toSet(),
            // circles: widget.,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  void initializeApiKey() async {
    String? key =
        await CarServiceIcon.getApiKey(); // Call the getApiKey() function
    setState(() {
      widget.googlekey = key;
    });
    getLocation();
    getPolyPoints();
  }
}
