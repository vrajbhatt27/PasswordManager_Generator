import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/passwordGenerator.dart';
import 'package:test_app/providers/credentials.dart';
import './popupCard.dart';
import '../../models/Security.dart';
import '../other/styles.dart';
import '../other/customRectTween.dart';
import '../other/heroDialogRoute.dart';

class ShowData extends StatefulWidget {
  final Function _updateData;

  ShowData(this._updateData);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Credential>(
      builder: (ctx, credential, _) => Container(
        // height: 500,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            String appId = credential.data.keys
                .elementAt(index); //extract the appId from data.
            String app =
                credential.data[appId]['app']; //extract app name from data
            String subtitle;

            // Here for subtitle in listtile, email is shown if it is present else mobile no is shown if it is present else nothing is shown.
            if (credential.data[appId].containsKey('email')) {
              subtitle = credential.data[appId]['email'];
            } else if (credential.data[appId].containsKey('mobile no')) {
              subtitle = credential.data[appId]['mobile no'];
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
                          //! ### change card color
                          color: AppColors.bgtColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Dismissible(
                          key: Key(appId),
                          background: Container(color: AppColors.accentColor),
                          onDismissed: (direction) {
                            setState(() {
                              credential.deleteData(appId);
                            });
                            Utils.dispToast("Deleted Successfully");
                          },
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                // It opens the popUpcard with animation.
                                HeroDialogRoute(
                                  builder: (context) => Center(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: PopUpCard(id: appId),
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
                                  //! ### change letter color in circle avater
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                              //! ### change bg color in circle avater
                              backgroundColor: AppColors.backgroundColor,
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
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                widget._updateData(context, appId: appId);
                              },
                            ),
                            onLongPress: () async {
                              if (credential.data[appId]
                                  .containsKey('password')) {
                                String pwd = await decrypt(
                                    credential.data[appId]['password']);
                                FlutterClipboard.copy(pwd);
                                Utils.dispToast('Password copied to clipboard');
                              } else {
                                Utils.dispToast('Password Not available');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      indent: 80,
                      thickness: 0.2,
                      endIndent: 80,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: credential.data.length,
        ),
      ),
    );
  }
}
