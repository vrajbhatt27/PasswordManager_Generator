import 'package:flutter/material.dart';
import 'package:test_app/models/Security.dart';

class PopUpCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  PopUpCard({@required this.data, @required this.id});

  @override
  _PopUpCardState createState() => _PopUpCardState();
}

class _PopUpCardState extends State<PopUpCard> {
  String pwdTitle = '----'; //It shows this text when the card pops up.
  Map info;

	// returns list of Text that contains all the info of selected app except password. 
  List<Widget> cardContent() { 
    info = widget.data[widget.id];

    List<Widget> lst = [];
    info.forEach((key, value) {
      if (key != 'password') {
        lst.add(Text(key + ': ' + value + '\n'));
      }
    });

    return lst;
  }

	// It returns a ListTile of password field which is shown on screen. If user taps it then the decrypt() is called and actual password is shown.
  Widget password() {
    return ListTile(
      leading: Text('Password: '),
      title: Text(pwdTitle),
      onTap: () async {
        String cipher = widget.data[widget.id]['password'];
        String pwd = await decrypt(cipher);
        setState(() {
          pwdTitle = pwd;
        });
      },
    );
  }

	// It is the main widget that is given to child of Dialog. It contains a column that calls cardContent and password if present.
  Widget popUpContent() {
    return Container(
        height: 200,
        width: 200,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...cardContent(),
              if(info.containsKey('password')) password(),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: popUpContent(),
    );
  }
}
