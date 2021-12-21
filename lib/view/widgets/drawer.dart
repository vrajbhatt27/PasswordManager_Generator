import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_app/view/other/heroDialogRoute.dart';
import 'package:test_app/view/other/styles.dart';
import 'package:test_app/view/widgets/generatePwdCard.dart';
import 'package:test_app/view/widgets/secMsgCard.dart';

class MyDrawer extends StatelessWidget {
	void _openGeneratePwd(BuildContext context) {
		Navigator.of(context).push(
      // It opens the popUpcard with animation.
      HeroDialogRoute(
        builder: (context) => Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GeneratePwdCard(),
          ), //AppPopupCard(appId)
        ),
      ),
    );
	}

	void _openSecretMsg(BuildContext context){
		Navigator.of(context).push(
      // It opens the popUpcard with animation.
      HeroDialogRoute(
        builder: (context) => Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SecretMsgCard(),
          ), //AppPopupCard(appId)
        ),
      ),
    );
	}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: ListView(
        children: [
          SizedBox(
            height: 150,
          ),
          Divider(
            color: Colors.white,
          ),
          DrawerCard('Generate Password', _openGeneratePwd),
          DrawerCard('Secret Message', _openSecretMsg),
        ],
      ),
    );
  }
}

class DrawerCard extends StatelessWidget {
  String _title;
  Function _action;
  DrawerCard(this._title, this._action);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () => _action(context),
      ),
    );
  }
}
