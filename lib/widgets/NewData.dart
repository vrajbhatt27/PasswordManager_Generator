import 'package:flutter/material.dart';

class NewData extends StatefulWidget {
  final Function callWrite2File;
  NewData(this.callWrite2File);
  @override
  _NewData createState() => _NewData();
}

class _NewData extends State<NewData> {
  TextEditingController keyCtrl = TextEditingController();
  TextEditingController valCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              labelText: 'Key',
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
          controller: keyCtrl,
        ),
        TextField(
          decoration: InputDecoration(
              labelText: 'Value',
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
          controller: valCtrl,
        ),
        ElevatedButton(
          onPressed: () => widget.callWrite2File(keyCtrl.text, valCtrl.text),
          child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
