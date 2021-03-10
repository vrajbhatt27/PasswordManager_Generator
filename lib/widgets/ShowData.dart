import 'package:flutter/material.dart';
import './popupCard.dart';

class ShowData extends StatefulWidget {
  // final List<Map> _dataLst;
  final Map<String, dynamic> data;

  ShowData(this.data) {
    print('In ShowData');
    print(data);
  }

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  void showPopUp(BuildContext ctx, Map<String, dynamic> data, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpCard(
            id: id,
            data: data,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          // String app = (widget.data[index].keys.toList()[0]).toString();
          // String email = widget.data[index][app]['email'];
          // String id = widget.data[index][app]['id'];

          // String pwd = dataLst[index][key]['email'];

          String appId = widget.data.keys.elementAt(index);
          String email = widget.data[appId]['email'];
          String app = widget.data[appId]['app'];

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            child: ListTile(
              onTap: () => showPopUp(context, widget.data, appId),
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
        itemCount: widget.data.length,
      ),
    );
  }
}
