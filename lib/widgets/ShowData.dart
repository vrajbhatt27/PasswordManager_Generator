import 'package:flutter/material.dart';
import './popupCard.dart';

class ShowData extends StatefulWidget {
  final List<Map> _dataLst;

  ShowData(this._dataLst) {
    print(_dataLst);
  }

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  void showPopUp(BuildContext ctx) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpCard();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String app = (widget._dataLst[index].keys.toList()[0]).toString();
          String email = widget._dataLst[index][app]['email'];
          String id = widget._dataLst[index][app]['id'];

          // String pwd = dataLst[index][key]['email'];

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            child: ListTile(
              onTap: () => showPopUp(context),
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('>'),
                  ),
                ),
              ),
              title: Text(app),
              subtitle: Text(email),
            ),
          );
        },
        itemCount: widget._dataLst.length,
      ),
    );
  }
}
