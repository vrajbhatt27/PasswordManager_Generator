import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../other/styles.dart';
import '../other/customRectTween.dart';
import '../../models/Security.dart';

class SecretMsgCard extends StatefulWidget {
  @override
  SecretMsgCardState createState() => SecretMsgCardState();
}

class SecretMsgCardState extends State<SecretMsgCard> {
  var width, height, pwd;
  final msgCtrl = TextEditingController();
  var encMsg, decMsg;

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
      height: height * 0.3,
      width: width * 0.7,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.popUpCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w600),
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.backgroundColor, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.backgroundColor,
                            width: 2,
                          )),
                      hintText: 'Enter',
                    ),
                  ),
                  flex: 12,
                  fit: FlexFit.loose,
                ),
                Flexible(
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      color: AppColors.backgroundColor,
                      onPressed: () {
                        FlutterClipboard.copy(msgCtrl.text);
                        dispToast('Copied To Clipboard');
                      },
                    ),
                    flex: 1,
                    fit: FlexFit.loose),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    color: AppColors.backgroundColor,
                    icon: Icon(Icons.lock_outline),
                    onPressed: () async {
                      encMsg = await encryptMsg(msgCtrl.text);
                      msgCtrl.text = encMsg;
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    color: AppColors.backgroundColor,
                    icon: Icon(Icons.lock_open),
                    onPressed: () async {
                      decMsg = await decryptMsg(msgCtrl.text);
                      msgCtrl.text = decMsg;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

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

/* TextButton(
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
 */
