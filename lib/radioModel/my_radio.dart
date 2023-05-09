import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      RadioModel(label: 'C', value: 'credit'),
      RadioModel(label: 'D', value: 'debit'),
      RadioModel(label: 'cs', value: 'cash')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listofData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: RadioListTile<String>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  selectedTileColor: Colors.green,
                  tileColor: Colors.amber,
                  title: Text(widget.listofData[index].label),
                  value: widget.listofData[index].value,
                  groupValue: widget.selectedvalue,
                  onChanged: (value) {
                    widget.selectedvalue = value as String;
                    setState(() {});
                    print('selected-->$value');
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AboutDialog(
                          applicationIcon: const Icon(Icons.abc),
                          children: [
                            Text('You selectd ${widget.selectedvalue}')
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            }));
  }
}
