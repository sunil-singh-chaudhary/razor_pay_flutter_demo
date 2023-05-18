import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_pay_flutter_demo/googleMap/location_provider.dart';

import 'googleMap/google_map.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // await DBHelper.database;
  FlutterError.onError = (FlutterErrorDetails details) {
    // Handle the error and log or display the error message and stack trace
    debugPrint('Flutter error: ${details.exception}');
    debugPrint('Stack trace:\n${details.stack}');
  };

  runZonedGuarded(() {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<LocationProvider>(
        create: (context) {
          return LocationProvider();
        },
      )
    ], child: const MyApp()));
  }, (error, stackTrace) {
    // Handle the error and log or display the error message and stack trace
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace:\n$stackTrace');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // PaymentModel formMap = PaymentModel();

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GoogleMapDemo(
          title: 'GOOGLE MAP',
        ),
      );
    });
  }
}
