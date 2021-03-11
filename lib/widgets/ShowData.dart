import 'package:flutter/material.dart';
import './popupCard.dart';

class ShowData extends StatefulWidget {
  // final List<Map> _dataLst;
  final Map<String, dynamic> data;
  final Function _updateData;
  final Function _deleteData;

  ShowData(this.data, this._updateData, this._deleteData) {
    // print('In ShowData');
    // print(data.toString() + '\n');
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
          String app = widget.data[appId]['app'];
          String subtitle;
          if (widget.data[appId].containsKey('email')) {
            subtitle = widget.data[appId]['email'];
          } else if (widget.data[appId].containsKey('mobile no')) {
            subtitle = widget.data[appId]['mobile no'];
          } else {
            subtitle = '';
          }

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
              subtitle: Text(subtitle),
              trailing: PopupMenuButton(
                onSelected: (choice) {
                  if (choice == 'Edit') {
                    widget._updateData(context,
                        data: widget.data, appId: appId);
                  } else if (choice == 'Delete') {
                    widget._deleteData(appId);
                  }
                },
                itemBuilder: (BuildContext ctx) {
                  return ['Edit', 'Delete'].map((choice) {
                    return PopupMenuItem(child: Text(choice), value: choice);
                  }).toList();
                },
              ),
            ),
          );
        },
        itemCount: widget.data.length,
      ),
    );
  }
}
