import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/backup.dart';
import 'package:test_app/models/hiveHandler.dart';
import 'package:test_app/models/passwordGenerator.dart';
import 'package:test_app/providers/credentials.dart';
import 'package:test_app/view/other/heroDialogRoute.dart';
import 'package:test_app/view/other/styles.dart';
import 'package:test_app/view/widgets/generatePwdCard.dart';
import 'package:test_app/view/widgets/secMsgCard.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  void _openGeneratePwd({BuildContext context}) {
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

  void _openSecretMsg({BuildContext context}) {
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
    await HiveHandler.restoreData();
    await Provider.of<Credential>(context, listen: false).fetchAndSetData();
    Utils.dispToast("Data Imported Successfully");
    // Navigator.of(context).pop();
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgtColor,
        title: Text('Settings'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GridCard('Generate\nPassword', _openGeneratePwd),
          GridCard('Secret\nMessage', _openSecretMsg),
          GridCard('Import\nData', _importData),
          GridCard('Export\nData', _exportData),
        ],
      ),
    );
  }
}

class GridCard extends StatelessWidget {
  final _title;
  final Function _action;
  GridCard(this._title, this._action);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.bgtColor,
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: InkWell(
				child: Center(
					child: Text(
						_title,
						style: TextStyle(
							fontSize: 24,
							fontWeight: FontWeight.bold,
						),
						textAlign: TextAlign.center,
					),
				),

				onTap: () => _action(context: context),
			),
    );
  }
}
