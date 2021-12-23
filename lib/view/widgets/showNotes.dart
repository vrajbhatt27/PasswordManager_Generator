import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/passwordGenerator.dart';
import 'package:test_app/providers/notes.dart';
import 'package:test_app/view/other/styles.dart';
import 'package:test_app/view/widgets/newNote.dart';

class ShowNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Notes>(builder: (ctx, notes, _) {
      return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          String noteId = notes.notesData.keys
              .elementAt(index); //extract the appId from data.
          String noteTitle = notes.notesData[noteId].keys.toList()[0];
          return GestureDetector(
            child: Card(
              elevation: 10,
              color: AppColors.bgtColor,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => NewNote(
                    noteId: noteId,
                  ),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppColors.backgroundColor,
                    title: Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to delete $noteTitle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close),
                      ),
                      IconButton(
                        onPressed: () {
                          notes.deleteNote(noteId);
                          Utils.dispToast('Note Deleted Successfully');
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.check),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        itemCount: notes.notesData.length,
      );
    });
  }
}
