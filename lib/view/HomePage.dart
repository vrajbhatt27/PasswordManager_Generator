import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/credentials.dart';
import './widgets/drawer.dart';
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
  var height;

  // Opens ModalBottomSheet. It calls NewData. Here if it is opening for update then appId is also passed.
  void _addNewData(BuildContext ctx, {String appId = ''}) {
    bool update = false;
    if (appId.isNotEmpty) {
      update = true;
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      //! ### modal bottom sheet bg color
      // backgroundColor: Color(0xFF1F2426),
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
                    height: height * 0.7,
                    child: NewData(
                      appId: appId,
                    ),
                  )
                : Container(
                    height: height * 0.7,
                    child: NewData(),
                  ),
            behavior: HitTestBehavior.opaque,
          ),
        );
      },
    );
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
    bool noDataInFile = Provider.of<Credential>(context).data.isEmpty;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: globalKey,
      endDrawer: Drawer(
        //Opens the drawer for direct password access.
        child: BackdropFilter(
          child: MyDrawer(),
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
        ),
        elevation: 30,
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
                margin: EdgeInsets.fromLTRB(10, 50, 0, 5),
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Credentials',
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 35,
                        ),
                        onPressed: () {
                          globalKey.currentState.openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.bottomLeft,
              ),

              // main body
              Container(
                height: height * 0.7,
                color: AppColors.backgroundColor,
                child: noDataInFile
                    ? showMsgWhenEmptyFile()
                    : ShowData(_addNewData),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bgtColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () => _addNewData(context),
      ),
    );
  }
}
