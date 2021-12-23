import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/notes.dart';
import 'package:test_app/view/other/styles.dart';

class ShowNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Notes>(builder: (ctx, notes, _) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (BuildContext context, int index) {
					String notesId = notes.notesData.keys
              .elementAt(index); //extract the appId from data.
          String noteTitle = notes.notesData[notesId].keys.toList()[0];
          return Card(
            elevation: 5,
            color: AppColors.bgtColor,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: InkWell(
              child: Center(
                child: Text(
                  noteTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {},
            ),
          );
        },
        itemCount: notes.notesData.length,
      );
    });
  }
}
