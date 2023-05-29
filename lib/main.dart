import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_pay_flutter_demo/googleMap/location_provider.dart';
import 'package:razor_pay_flutter_demo/provider_star/star_count.dart';

import 'googleMap/google_map.dart';
import 'package:sizer/sizer.dart';

import 'home_page.dart';
import 'payment_feature/payment_model.dart';
import 'payment_feature/payment_screen.dart';

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
      ),
      ChangeNotifierProvider<StarCountProvider>(
        create: (context) {
          return StarCountProvider();
        },
      ),
    ], child: MyApp()));
  }, (error, stackTrace) {
    // Handle the error and log or display the error message and stack trace
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace:\n$stackTrace');
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  PaymentModel formMap = PaymentModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: HomePage(),

        // GoogleMapDemo(
        //   title: 'GOOGLE MAP',
        // ),
      );
    });
  }
}
