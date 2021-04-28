import 'dart:io';
import 'dart:convert';
import 'dart:ui';
// ignore: unused_import
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../other/styles.dart';
import '../widgets/generatePwdCard.dart';
import '../other/customRectTween.dart';
import '../widgets/NewData.dart';
import '../widgets/ShowData.dart';
import '../models/FileHandler.dart';
import '../other/heroDialogRoute.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _jsonFile;
  Directory _dir;
  bool _fexists = false;
  String _fname = 'data.json';
  Map<String, dynamic> _data = {};
  var height;

  // Instantiate the _dir and _file and reads data from jsonFile that are shown on screen.
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      _dir = directory;
      _jsonFile = File(_dir.path + '/' + _fname);
      _fexists = _jsonFile.existsSync();
      if (_fexists) {
        setState(() {
          _data = jsonDecode(_jsonFile.readAsStringSync());
          // dataLst = map2List(_data);
        });
      }
    });
  }

  // calls write2File() of FileFandler and writes data into jsonFile.
  void _callWrite2File(String key, dynamic value) {
    FileHandler fh = FileHandler(_jsonFile);
    fh.write2File(key, value);

    this.setState(() {
      _data = jsonDecode(_jsonFile.readAsStringSync());
    });
  }

  // Opens ModalBottomSheet. It calls NewData. Here if it is opening for update then args data and appId are also passed with callwrite2file method.
  void _addNewData(BuildContext ctx, {dynamic data = '', String appId = ''}) {
    bool update = false;
    if (appId.isNotEmpty) {
      update = true;
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Color(0xFF1F2426),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: update
              ? Container(
                  height: height * 0.6,
                  child: NewData(
                    _callWrite2File,
                    data: data,
                    appId: appId,
                  ),
                )
              : Container(
                  height: height * 0.6,
                  child: NewData(_callWrite2File),
                ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  // Deletes the given app info and calls deleteData of fileHandler. It also calls setState so that the deleted app info is removed from screen
  void _deleteData(String appId) {
    _data.remove(appId);
    FileHandler fh = FileHandler(_jsonFile);
    fh.deleteData(_data);
    setState(() {
      _data = jsonDecode(_jsonFile.readAsStringSync());
    });
  }

  Widget showMsgWhenEmptyFile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => _addNewData(context),
            child: Image.asset(
              'assets/Images/EmptyFile.png',
              scale: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'No data present. Start adding your credentials...',
              style: TextStyle(
                color: AppColors.popUpCardColor,
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
    bool noDataInFile = _data.isEmpty;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Credentials',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor),
                  ),
                  Hero(
                    createRectTween: (begin, end) {
                      return CustomRectTween(begin: begin, end: end);
                    },
                    tag: 'menu',
                    child: Material(
											color: AppColors.accentColor,
                      child: PopupMenuButton(
                        //Three dots menu
                        onSelected: (choice) {
                          if (choice == 'Generate Passwords') {
                            print('Password Generate');
                            Navigator.of(context).push(
                              // It opens the popUpcard with animation.
                              HeroDialogRoute(
                                builder: (context) => Center(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: GeneratePwdCard(),
                                  ), //AppPopupCard(appId)
                                ),
                              ),
                            );
                          } else if (choice == 'Encrypted Messages') {
                            print('Encrypt Password');
                          }
                        },
                        itemBuilder: (BuildContext ctx) {
                          return ['Generate Passwords', 'Encrypted Messages']
                              .map((choice) {
                            return PopupMenuItem(
                                child: Text(choice), value: choice);
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              alignment: Alignment.bottomLeft,
            ),
            Container(
              height: height * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundColor,
                    AppColors.backgroundFadedColor,
                  ],
                  // stops: [0.0, 1],
                ),
              ),
              child: noDataInFile
                  ? showMsgWhenEmptyFile()
                  : ShowData(_data, _addNewData, _deleteData),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentColor,
        child: Icon(Icons.add),
        onPressed: () => _addNewData(context),
      ),
    );
  }
}
