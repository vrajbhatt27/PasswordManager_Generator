import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../providers/credentials.dart';
import '../providers/notes.dart';
import './settingsPage.dart';
import './widgets/newNote.dart';
import './widgets/showNotes.dart';
import './other/styles.dart';
import './widgets/NewData.dart';
import './widgets/ShowData.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  var _height;
  bool _notesSelected = false;

  // Opens ModalBottomSheet. It calls NewData(for credentials). Here if it is opening for update then appId is also passed.
  void _addNewData(BuildContext ctx, {String appId = ''}) {
    bool update = false;
    if (appId.isNotEmpty) {
      update = true;
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (bCtx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          child: GestureDetector(
            onTap: () {},
            child: update
                ? Container(
                    height: _height * 0.7,
                    child: NewData(
                      appId: appId,
                    ),
                  )
                : Container(
                    height: _height * 0.7,
                    child: NewData(),
                  ),
            behavior: HitTestBehavior.opaque,
          ),
        );
      },
    );
  }

  Widget showMsgWhenEmptyFile() {
    String dataName = _notesSelected ? 'notes' : 'credentials';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/Images/EmptyFile.png',
            scale: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'No data present. Start adding your $dataName...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool noDataInFile =
        _notesSelected ? Provider.of<Notes>(context).notesData.isEmpty : Provider.of<Credential>(context).data.isEmpty;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: globalKey,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _notesSelected = false;
                  });
                },
                icon: Icon(
                  Icons.privacy_tip_outlined,
                  size: 30,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _notesSelected = true;
                  });
                },
                icon: Icon(
                  Icons.notes,
                  size: 30,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                onPressed: () {
                  // globalKey.currentState.openEndDrawer();
                  Navigator.of(context).pushNamed(SettingsPage.routeName);
                },
                icon: Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: AppColors.bgtColor,
        notchMargin: 8,
        elevation: 5,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // app bar
              Container(
                margin: EdgeInsets.fromLTRB(10, 50, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        _notesSelected ? 'Notes' : 'Credentials',
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.bottomLeft,
              ),

              // main body
              Container(
                height: _height * 0.73,
                color: AppColors.backgroundColor,
                child: noDataInFile
                    ? showMsgWhenEmptyFile()
                    : _notesSelected
                        ? ShowNotes()
                        : ShowData(_addNewData),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        iconTheme: IconThemeData(color: Colors.white, size: 40),
        backgroundColor: AppColors.bgtColor,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.privacy_tip_outlined,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            label: 'Credential',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            labelBackgroundColor: Colors.white,
            onTap: () => _addNewData(context),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.notes,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            label: 'Notes',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            labelBackgroundColor: Colors.white,
            onTap: () {
              Navigator.of(context).pushNamed(NewNote.routeName);
            },
          ),
        ],
      ),
    );
  }
}
