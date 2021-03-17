import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';
import './popupCard.dart';
import '../models/Security.dart';
import '../other/styles.dart';
import '../other/customRectTween.dart';
import '../other/heroDialogRoute.dart';

class ShowData extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function _updateData;
  final Function _deleteData;

  ShowData(this.data, this._updateData, this._deleteData);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  // It shows the popUpCard for displaying the details of app.
  // ignore: unused_element
  void _showPopUp(BuildContext ctx, Map<String, dynamic> data, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpCard(
            // calls PopUpCard of popupCard.dart
            id: id,
            data: data,
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String appId =
              widget.data.keys.elementAt(index); //extract the appId from data.
          String app = widget.data[appId]['app']; //extract app name from data
          String subtitle;

          // Here for subtitle in listtile, email is shown if it is present else mobile no is shown if it is present else nothing is shown.
          if (widget.data[appId].containsKey('email')) {
            subtitle = widget.data[appId]['email'];
          } else if (widget.data[appId].containsKey('mobile no')) {
            subtitle = widget.data[appId]['mobile no'];
          } else {
            subtitle = '';
          }

          return Hero(
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            tag: appId,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
														// It opens the popUpcard with animation.
                            HeroDialogRoute(
                              builder: (context) => Center(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child:
                                      PopUpCard(data: widget.data, id: appId),
                                ), //AppPopupCard(appId)
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 27,
                          child: Text(
                            app.split('')[0],
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          backgroundColor: AppColors.accentColor,
                        ),
                        title: Text(
                          app,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        trailing: PopupMenuButton(
                          //Three dots menu
                          onSelected: (choice) {
                            //If user selects Edit then updateData is called which is _addNewData from main.dart that opens modalBottomSheet with filled details. And if user selects Delete then _deleteData is called.
                            if (choice == 'Edit') {
                              widget._updateData(context,
                                  data: widget.data, appId: appId);
                            } else if (choice == 'Delete') {
                              widget._deleteData(appId);
                            }
                          },
                          itemBuilder: (BuildContext ctx) {
                            return ['Edit', 'Delete'].map((choice) {
                              return PopupMenuItem(
                                  child: Text(choice), value: choice);
                            }).toList();
                          },
                        ),
                        onLongPress: () async {
                          if (widget.data[appId].containsKey('password')) {
                            String pwd =
                                await decrypt(widget.data[appId]['password']);
                            FlutterClipboard.copy(pwd);
                            dispToast('Password copied to clipboard');
                          } else {
                            dispToast('Password Not available');
                          }
                        },
                      ),
                    ),
                  ),
                  Divider(color: AppColors.popUpCardColor),
                ],
              ),
            ),
          );
        },
        itemCount: widget.data.length,
      ),
    );
  }
}
