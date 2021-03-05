import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  final Map<String, dynamic> _data;

  ShowData(this._data);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: Text(
          widget._data.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
