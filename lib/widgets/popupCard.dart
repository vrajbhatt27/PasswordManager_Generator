import 'package:flutter/material.dart';

class PopCard extends StatefulWidget {
  @override
  _PopCardState createState() => _PopCardState();
}

class _PopCardState extends State<PopCard> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: PopUpContent(),
    );
  }
}

class PopUpContent extends StatelessWidget {
  
	

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [],
        ));
  }
}
