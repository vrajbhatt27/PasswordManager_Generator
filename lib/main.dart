import 'package:flutter/material.dart';
import './widgets/NewData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test(),
    );
  }
}

class Test extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Json Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NewData(),
            ],
          ),
        ));
  }
}
