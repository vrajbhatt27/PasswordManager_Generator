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
  String _pwdTitle = '....'; //It shows this text when the card pops up.
  var _info = {};
  var _height;
  var _width;
  bool _isShown = false;

  @override
  void initState() {
    super.initState();
    _info = Provider.of<Credential>(context, listen: false).findById(widget.id);
  }

  // Defines how the text is shown on Card.
  Widget _showText(String key, String val) {
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
  List<Widget> _cardContent() {
    List<Widget> lst = [];
    _info.forEach(
      (key, value) {
        if (key != 'password' && key != 'app') {
          lst.add(_showText(key, value));
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
  Widget _password() {
    return InkWell(
        child: _showText('Password', _pwdTitle),
        onTap: () async {
          if (_isShown == false)
            _isShown = true;
          else
            _isShown = false;
          String cipher = _info['password'];
          String pwd = await decrypt(cipher);
          setState(() {
            if (_isShown) {
              _pwdTitle = pwd;
            } else {
              _pwdTitle = '....';
            }
          });
        });
  }

  // It is the main widget that is given to child of Dialog. It contains a column that calls cardContent and password if present.
  Widget _popUpContent() {
    return Container(
      height: _height * 0.4,
      width: _width * 0.5,
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
              _info['app'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundColor,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ..._cardContent(),
            if (_info.containsKey('password')) _password(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
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
            borderRadius: BorderRadius.circular(16), child: _popUpContent()),
      ),
    );
  }
}
