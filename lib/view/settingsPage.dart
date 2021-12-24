import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/backup.dart';
import '../models/hiveHandler.dart';
import '../models/passwordGenerator.dart';
import '../providers/credentials.dart';
import '../providers/notes.dart';
import './other/heroDialogRoute.dart';
import './other/styles.dart';
import './widgets/generatePwdCard.dart';
import './widgets/secMsgCard.dart';
import './widgets/setPassword.dart';

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
    Map<String, bool> restored = await HiveHandler.restoreData();

    if (restored['credentials']) {
      await Provider.of<Credential>(context, listen: false).fetchAndSetData();
    }

    if (restored['notes']) {
      await Provider.of<Notes>(context, listen: false).fetchAndSetNotesData();
    }

    if (restored['credentials'] && restored['notes'] && restored['data']) {
      Utils.dispToast("Data Imported Successfully");
    } else if (restored['credentials'] ||
        restored['notes'] ||
        restored['data']) {
      Utils.dispToast('Available Data Imported Successfully');
    } else {
      Utils.dispToast('No Data Available');
    }
  }

  void _exportData({BuildContext context}) async {
    await Backup.initDir();

    Map<String, dynamic> data =
        Provider.of<Credential>(context, listen: false).data;
    Backup.backup('credentials', data);

    data = await HiveHandler('data').read();
    Backup.backup('data', data);

    data = Provider.of<Notes>(context, listen: false).notesData;
    Backup.backup('notes', data);

    //! Optimization: If success then only show this.
    Utils.dispToast('Data Exported Successfully');
  }

  void _changePassword({BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SetPassword();
      },
    );
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
          GridCard('Change\nPassword', _changePassword),
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
