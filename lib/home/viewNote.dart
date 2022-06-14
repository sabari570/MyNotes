import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final DocumentReference ref;
  final Map data;
  ViewNote({this.ref, this.data});
  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  String titleText;
  String contentText;
  bool editable = false;
  TextEditingController title;
  TextEditingController content;
  void deleteRecord() async {
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void updateRecord() async {
    await widget.ref.updateData({
      'title': title.text ?? widget.data['title'],
      'content': content.text ?? widget.data['content'],
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    titleText = widget.data['title'];
    contentText = widget.data['content'];
    title = TextEditingController(text: titleText);
    content = TextEditingController(text: contentText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'View Note',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            width: 50,
            margin: EdgeInsets.only(
              right: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  editable = !editable;
                });
              },
            ),
          ),
          Container(
            width: 50,
            margin: EdgeInsets.only(
              right: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(Icons.delete_forever_rounded),
              onPressed: () {
                deleteRecord();
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8,
        ),
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: title,
              enabled: editable,
              style: editable
                  ? TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    )
                  : TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
              decoration: InputDecoration(
                filled: true,
                fillColor: editable ? Colors.white : Colors.black,
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextField(
                controller: content,
                enabled: editable,
                style: editable
                    ? TextStyle(
                        fontSize: 22,
                      )
                    : TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: editable ? Colors.white : Colors.black,
                  hintText: 'Enter your content here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateRecord();
        },
        backgroundColor: Colors.greenAccent[700],
        child: Icon(
          Icons.save_outlined,
          size: 25,
        ),
      ),
    );
  }
}
