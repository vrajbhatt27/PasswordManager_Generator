import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/backup.dart';
import 'package:test_app/models/hiveHandler.dart';
import 'package:test_app/models/passwordGenerator.dart';
import 'package:test_app/providers/credentials.dart';
import 'package:test_app/view/HomePage.dart';
import 'package:test_app/view/other/heroDialogRoute.dart';
import 'package:test_app/view/other/styles.dart';
import 'package:test_app/view/widgets/generatePwdCard.dart';
import 'package:test_app/view/widgets/secMsgCard.dart';

class MyDrawer extends StatelessWidget {
  void _openGeneratePwd({context}) {
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

  void _openSecretMsg({context}) {
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

  void _importData({BuildContext context}) async {
    HiveHandler.restoreData();
    await Provider.of<Credential>(context, listen: false).fetchAndSetData();
    Utils.dispToast("Data Imported Successfully");
    Navigator.of(context).popAndPushNamed(HomePage.routeName);
  }

  void _exportData({BuildContext context}) async {
    Map<String, dynamic> data =
        Provider.of<Credential>(context, listen: false).data;
    Backup.backup('credentials', data);

    data = await HiveHandler('data').read();
    Backup.backup('data', data);

    Utils.dispToast('Data Exported Successfully');
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
          DrawerCard('Import Data', _importData),
          DrawerCard('Export Data', _exportData),
        ],
      ),
    );
  }
}

class DrawerCard extends StatelessWidget {
  final String _title;
  final Function _action;
  final bool noContext;
  DrawerCard(this._title, this._action, {this.noContext = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
			color: AppColors.bgtColor,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: noContext ? _action : () => _action(context: context),
      ),
    );
  }
}
