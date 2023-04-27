import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:razor_pay_flutter_demo/payment_model.dart';
import 'package:razor_pay_flutter_demo/payment_screen.dart';

String KEY_ID = 'rzp_test_1ntALFaaETMdzg';
String KEY_SECRET = 'r5tAwc6ESVTpndVu6VOCk741';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _globalkey = GlobalKey<FormState>();
  PaymentModel? _formMap = PaymentModel();
  Prefill prefilmodel = Prefill();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _globalkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const ValueKey('firstkey'),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  //  _formMap['amount'] = value;
                  _formMap!.amount = value;
                },
              ),
              TextFormField(
                key: const ValueKey('secondkey'),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _formMap['name'] = value;
                  _formMap!.name = value;
                },
              ),
              TextFormField(
                key: const ValueKey('thirdkey'),
                decoration: const InputDecoration(
                  labelText: 'Descitpiton',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Descrption';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _formMap['description'] = value;
                  _formMap!.description = value;
                },
              ),
              TextFormField(
                key: const ValueKey('fourthkey'),
                decoration: const InputDecoration(
                  labelText: 'mobilno',
                  border: OutlineInputBorder(),
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
              TextFormField(
                key: const ValueKey('fifthkey'),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please validemail';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _formMap['email'] = value;
                  prefilmodel.email = value!;
                },
              ),
            ],
          )),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              if (_globalkey.currentState!.validate()) {
                _globalkey.currentState!.save();

                Retry retrymdel = Retry(enabled: 'true', maxCount: '1');
                _formMap?.prefill = prefilmodel;
                _formMap?.sendSmsHash = 'true';
                External ext_model = External(wallets: ['paytm']);

                _formMap?.key = KEY_ID;
                _formMap?.retry = retrymdel;
                _formMap?.sendSmsHash = 'true';
                _formMap?.paymentModelExternal = ext_model;

                print(json.encode(_formMap?.toJson()));
                NavigateToFinalScreen(_formMap);
              }
            },
            child: const Text('Pay')),
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
}
