import 'package:flutter/material.dart';

class PopUpCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id;

  PopUpCard({@required this.data, @required this.id});
	
  Widget popUpContent() {
    Map info = data[id];
    return Container(
        height: 200,
        width: 200,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
					children: info.entries.map((e) => Text(e.key + ': ' + e.value + '\n')).toList(),
				));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: popUpContent(),
    );
  }
}
