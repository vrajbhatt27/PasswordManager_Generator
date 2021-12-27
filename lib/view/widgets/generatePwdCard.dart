import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import '../../models/passwordGenerator.dart';
import '../other/customRectTween.dart';
import '../other/styles.dart';

class GeneratePwdCard extends StatefulWidget {
  @override
  _GeneratePwdCardState createState() => _GeneratePwdCardState();
}

class _GeneratePwdCardState extends State<GeneratePwdCard> {
  var _width, _height, _pwd;

  @override
  initState() {
    super.initState();
    _pwd = Utils().generatePassword();
  }

  Widget popUpContent() {
    return Container(
      height: _height * 0.25,
      width: _width * 0.5,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.popUpCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                  _pwd,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _pwd = Utils().generatePassword();
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
                Text(
                  '|',
                  style: TextStyle(
                    color: AppColors.backgroundColor.withOpacity(0.5),
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  color: AppColors.backgroundColor,
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    FlutterClipboard.copy(_pwd);
                    Utils.dispToast('Copied To Clipboard');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
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
