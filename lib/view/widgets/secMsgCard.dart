import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import '../../models/passwordGenerator.dart';
import '../other/styles.dart';
import '../other/customRectTween.dart';
import '../../models/Security.dart';

class SecretMsgCard extends StatefulWidget {
  @override
  SecretMsgCardState createState() => SecretMsgCardState();
}

class SecretMsgCardState extends State<SecretMsgCard> {
  FocusNode _fn = FocusNode();
  var width, height, pwd;
  final _msgCtrl = TextEditingController();
  var encMsg, decMsg;

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
                    focusNode: _fn,
                    style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w600),
                    controller: _msgCtrl,
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
                      hintStyle: TextStyle(
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                  flex: 9,
                  fit: FlexFit.loose,
                ),
                Flexible(
                    child: IconButton(
                      icon: Icon(
                        Icons.copy,
                        size: 30,
                      ),
                      color: AppColors.backgroundColor,
                      onPressed: () {
                        FlutterClipboard.copy(_msgCtrl.text);
                        Utils.dispToast('Copied To Clipboard');
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
                      if (_msgCtrl.text.isNotEmpty) {
                        _fn.unfocus();
                        encMsg = await encryptMsg(_msgCtrl.text);
                        _msgCtrl.text = encMsg;
                      }
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    color: AppColors.backgroundColor,
                    icon: Icon(Icons.lock_open),
                    onPressed: () async {
                      if (_msgCtrl.text.isNotEmpty) {
                        _fn.unfocus();
                        decMsg = await decryptMsg(_msgCtrl.text);
                        _msgCtrl.text = decMsg;
                      }
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