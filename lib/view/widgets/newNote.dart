import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/passwordGenerator.dart';
// import 'package:test_app/models/Security.dart';
import 'package:test_app/view/other/styles.dart';
import '../../providers/notes.dart';

class NewNote extends StatefulWidget {
  static const routeName = 'addNewNote';
  final String noteId;

  NewNote({this.noteId = ''});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  var _height;
  bool validatation = true;
  bool read = false;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();
  final FocusNode _contentFn = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.noteId.isNotEmpty) {
      _forRead();
      read = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _contentFn.dispose();
  }

  void _forRead() {
    Map info =
        Provider.of<Notes>(context, listen: false).findById(widget.noteId);

    _titleCtrl.text = info.keys.toList()[0];
    _contentCtrl.text = info.values.toList()[0];
  }

  bool validate(String str) {
    if (str.isEmpty) {
      return false;
    }

    return true;
  }

  // returns a unique id for appId:appInfo in jsonFile. This acts as appId.
  String _noteId(noteTitle) {
    String uniqId = DateTime.now().toString();
    var lst = uniqId.split('');
    lst = lst.where((e) {
      if (e == '-' || e == '.' || e == ':' || e == ' ') {
        return false;
      }
      return true;
    }).toList();
    String id = '';
    for (var e in lst) {
      id += e;
    }

    return noteTitle + id;
  }

  Future<void> _addNote() async {
    String noteTitle = _titleCtrl.text;
    String noteContent = _contentCtrl.text;

		noteTitle = noteTitle.replaceRange(0, 1, noteTitle.split('')[0].toUpperCase());

    String id = (widget.noteId.isNotEmpty) ? widget.noteId : _noteId(noteTitle);

    Map<String, dynamic> notesData = {noteTitle: noteContent};
    await Provider.of<Notes>(context, listen: false).addNote({id: notesData});

    Navigator.of(context).pop();
  }

  Future<void> _deleteNote() async {
    await Provider.of<Notes>(context, listen: false).deleteNote(widget.noteId);
    Utils.dispToast('Note Deleted Successfully');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('New Note'),
        backgroundColor: AppColors.bgtColor,
        actions: [
          if (widget.noteId.isNotEmpty)
            IconButton(
              onPressed: _deleteNote,
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 32,
              ),
            ),
        ],
      ),
      body: Container(
        height: _height,
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              readOnly: read,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: validatation ? "Title" : "Add Note Title",
                hintStyle: validatation ? null : TextStyle(color: Colors.red),
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 5),
              ),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 5,
              endIndent: 55,
            ),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                focusNode: _contentFn,
                keyboardType: TextInputType.multiline,
                readOnly: read,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your Note",
                  hintStyle: TextStyle(fontSize: 20),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onTap: () {
                  if (read) {
                    setState(() {
                      read = false;
                    });
                    _contentFn.requestFocus();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: read ? null : FloatingActionButton(
        child: Icon(
          Icons.save,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          if (!validate(_titleCtrl.text)) {
            setState(() {
              validatation = false;
            });
            return;
          }
          if (!validate(_contentCtrl.text)) {
            Utils.dispToast('Can\'t add an empty note !!!');
            return;
          }

          _addNote();
        },
        backgroundColor: AppColors.bgtColor,
      ),
    );
  }
}
