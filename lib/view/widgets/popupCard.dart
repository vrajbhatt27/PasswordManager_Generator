import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Security.dart';
import '../../providers/credentials.dart';
import '../other/styles.dart';
import '../other/customRectTween.dart';

class PopUpCard extends StatefulWidget {
  final String id;

  PopUpCard({@required this.id});

  @override
  _PopUpCardState createState() => _PopUpCardState();
}

class _PopUpCardState extends State<PopUpCard> {
  String pwdTitle = '....'; //It shows this text when the card pops up.
  var info = {};
  var height;
  var width;
  bool isShown = false;

  @override
  void initState() {
    super.initState();
    info = Provider.of<Credential>(context, listen: false).findById(widget.id);
  }

  // Defines how the text is shown on Card.
  Widget showText(String key, String val) {
    key = key.replaceRange(0, 1, key.split('')[0].toUpperCase());
    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              "$key: ",
              style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900),
            ),
            Text(
              " $val ",
              style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // returns list of Text that contains all the info of selected app except password.
  List<Widget> cardContent() {
    List<Widget> lst = [];
    info.forEach(
      (key, value) {
        if (key != 'password' && key != 'app') {
          lst.add(showText(key, value));
          lst.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 5,
                color: AppColors.backgroundColor,
                endIndent: 7,
                indent: 7,
              ),
            ),
          );
        }
      },
    );

    return lst;
  }

  // It returns a ListTile of password field which is shown on screen. If user taps it then the decrypt() is called and actual password is shown.
  Widget password() {
    return InkWell(
        child: showText('Password', pwdTitle),
        onTap: () async {
          if (isShown == false)
            isShown = true;
          else
            isShown = false;
          String cipher = info['password'];
          String pwd = await decrypt(cipher);
          setState(() {
            if (isShown) {
              pwdTitle = pwd;
            } else {
              pwdTitle = '....';
            }
          });
        });
  }

  // It is the main widget that is given to child of Dialog. It contains a column that calls cardContent and password if present.
  Widget popUpContent() {
    return Container(
      height: height * 0.4,
      width: width * 0.5,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.popUpCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              info['app'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundColor,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ...cardContent(),
            if (info.containsKey('password')) password(),
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
        tag: widget.id,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Material(
            borderRadius: BorderRadius.circular(16), child: popUpContent()),
      ),
    );
  }
}
