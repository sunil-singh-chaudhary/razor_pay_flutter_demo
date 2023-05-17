import 'package:flutter/material.dart';
import 'package:razor_pay_flutter_demo/radioModel/CustomRadioListTile.dart';
import 'package:sizer/sizer.dart';

import 'radio_model.dart';

class MyRadioButtonGroup extends StatefulWidget {
  MyRadioButtonGroup({super.key});
  List<RadioModel> listofData = [];
  String selectedvalue = 'Credit Card';
  @override
  State<MyRadioButtonGroup> createState() => _MyRadioButtonGroupState();
}

class _MyRadioButtonGroupState extends State<MyRadioButtonGroup> {
  @override
  void initState() {
    super.initState();
    widget.listofData = [
      RadioModel(value: 'credit'),
      RadioModel(value: 'debit'),
      RadioModel(value: 'cash'),
      RadioModel(value: 'second')
    ];
  }

  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      height: 18.h, // Set the desired height for the container
      width: 20.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomRadioButton<int>(
            colorbackground: Colors.orange,
            value: 0,
            groupValue: _value,
            onChanged: (value) {
              setState(() => _value = value!);
            },
          ),
          CustomRadioButton<int>(
            colorbackground: Colors.green,
            value: 1,
            groupValue: _value,
            onChanged: (value) {
              setState(() => _value = value!);
            },
          ),
          CustomRadioButton<int>(
            colorbackground: Colors.blue,
            value: 2,
            groupValue: _value,
            onChanged: (value) {
              setState(() => _value = value!);
            },
          ),
          CustomRadioButton<int>(
            colorbackground: Colors.yellow,
            value: 3,
            groupValue: _value,
            onChanged: (value) {
              setState(() => _value = value!);
              print(_value);
            },
          ),
        ],
      ),
    );
  }
}


// showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AboutDialog(
//                     applicationIcon: const Icon(Icons.abc),
//                     children: [Text('You selectd ${widget.selectedvalue}')],
//                   );
//                 },
//               );