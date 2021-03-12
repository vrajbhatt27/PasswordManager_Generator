import 'package:flutter/material.dart';
import './popupCard.dart';

class ShowData extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function _updateData;
  final Function _deleteData;

  ShowData(this.data, this._updateData, this._deleteData);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
	// It shows the popUpCard for displaying the details of app.
  void _showPopUp(BuildContext ctx, Map<String, dynamic> data, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpCard(   // calls PopUpCard of popupCard.dart
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
          String appId = widget.data.keys.elementAt(index); //extract the appId from data.
          String app = widget.data[appId]['app']; //extract app name from data
          String subtitle;

					// Here for subtitle in listtile, email is shown if it is present else mobile no is shown if it is present else nothing is shown.
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
              onTap: () => _showPopUp(context, widget.data, appId),
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
              trailing: PopupMenuButton( //Three dots menu
                onSelected: (choice) { //If user selects Edit then updateData is called which is _addNewData from main.dart that opens modalBottomSheet with filled details. And if user selects Delete then _deleteData is called.
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
