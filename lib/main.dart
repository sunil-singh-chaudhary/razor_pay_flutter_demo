import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_pay_flutter_demo/home_page.dart';

import 'Database/database_helper.dart';
import 'payment_feature/payment_model.dart';
import 'payment_feature/payment_screen.dart';
import 'package:sizer/sizer.dart';

import 'provider_star/star_count.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBHelper.database;
  runApp(
    ChangeNotifierProvider(
      create: (_) => StarCountProvider(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
    });
  }
}
