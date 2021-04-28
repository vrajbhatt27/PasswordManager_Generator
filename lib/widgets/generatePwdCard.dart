import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';
import '../models/passwordGenerator.dart';
import '../other/customRectTween.dart';
import '../other/styles.dart';

class GeneratePwdCard extends StatefulWidget {
  @override
  _GeneratePwdCardState createState() => _GeneratePwdCardState();
}

class _GeneratePwdCardState extends State<GeneratePwdCard> {
  var width, height, pwd;

  @override
  initState() {
    super.initState();
    pwd = GeneratePassword().generatePassword();
  }

  // Shows the toast message.
  void dispToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.popUpCardColor,
      textColor: AppColors.backgroundColor,
      fontSize: 16.0,
    );
  }

  Widget popUpContent() {
    return Container(
      height: height * 0.25,
      width: width * 0.5,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.popUpCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  pwd = GeneratePassword().generatePassword();
                });
              },
              child: Container(
                height: 40,
                // width: 170,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(10),
                child: Text(
                  pwd,
                  style: TextStyle(
                    color: AppColors.popUpCardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                FlutterClipboard.copy(pwd);
                dispToast('Copied To Clipboard');
              },
              child: Text(
                'Copy',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
	
	SingleChildScrollView(
      child: Container(
        height: height * 0.25,
        width: width * 0.5,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.popUpCardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    // width: 170,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      pwd,
                      style: TextStyle(
                        color: AppColors.popUpCardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      FlutterClipboard.copy(pwd);
                      dispToast('Copied To Clipboard');
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pwd = GeneratePassword().generatePassword();
                });
              },
              child: Text(
                'Generate',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    )
	
	 */

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Hero(
        tag: 'menu',
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Material(
          borderRadius: BorderRadius.circular(16),
          child: popUpContent(),
        ),
      ),
    );
  }
}
