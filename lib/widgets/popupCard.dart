import 'package:flutter/material.dart';

class PopUpCard extends StatelessWidget {
  
  Widget popUpContent() {
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
