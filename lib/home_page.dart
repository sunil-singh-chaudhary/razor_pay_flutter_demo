// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razor_pay_flutter_demo/payment_feature/db_user.dart';

import 'Database/database_helper.dart';
import 'payment_feature/payment_model.dart';
import 'payment_feature/payment_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? apiKey;
  String? secretKey;
  List<User> userList = [];
  DBHelper dbHelper = DBHelper();
  @override
  void initState() {
    super.initState();
    LoadKey();

    getDBData();
  }

  getDBData() async {
    final db_dataList = await dbHelper.getDataFromDatabase();
    setState(() {
      userList = db_dataList;
    });
  }

  final _globalkey = GlobalKey<FormState>();
  final _formMap = PaymentModel();
  Prefill prefilmodel = Prefill();
  @override
  Widget build(BuildContext context) {
    if (userList.isNotEmpty) {
      print(userList[0].paymentID);
      print(userList[0].orderId);
      print(userList[0].orderPrice);
      print(userList[0].orderDetails);
    } else {
      // handle the case when userList is empty
      return const CircularProgressIndicator();
    }
    // return your widget tree here
    return Scaffold(
      appBar: AppBar(title: const Text('Razor Pay')),
      body: SingleChildScrollView(
        child: Form(
            key: _globalkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const ValueKey('amountKey'),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Amount';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      //  _formMap['amount'] = value;
                      _formMap.amount = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const ValueKey('nameKey'),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _formMap['name'] = value;
                      _formMap.name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const ValueKey('descptKeyp'),
                    decoration: const InputDecoration(
                      labelText: 'Descitpiton',
                      hintText: 'Enter description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Descrption';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _formMap['description'] = value;
                      _formMap.description = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const ValueKey('phoneKeye'),
                    decoration: const InputDecoration(
                      labelText: 'mobilno',
                      hintText: 'Enter Phone no',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10) {
                        return 'Please enter valid phone no';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _formMap['contact'] = value;
                      prefilmodel.contact = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    key: const ValueKey('emailKey'),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email id',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please entervalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _formMap['email'] = value;
                      prefilmodel.email = value!;
                    },
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (_globalkey.currentState!.validate()) {
                _globalkey.currentState!.save();

                Retry retrymdel = Retry(enabled: 'true', maxCount: '1');
                _formMap.prefill = prefilmodel;
                _formMap.sendSmsHash = 'true';

                External ext_model = External(wallets: ['paytm']);

                _formMap.key = apiKey;
                _formMap.retry = retrymdel;
                _formMap.sendSmsHash = 'true';
                _formMap.paymentModelExternal = ext_model;

                print(json.encode(_formMap.toJson()));
                NavigateToFinalScreen(_formMap);
              }
            },
            child: const Text('Submit')),
      ),
    );
  }

  void NavigateToFinalScreen(var formMap) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            formMap: formMap,
          ),
        ));
  }

  void LoadKey() async {
    await dotenv.load();
    apiKey = dotenv.env['KEY_ID'];
    secretKey = dotenv.env['KEY_SECRET'];
    setState(() {});
  }
}
