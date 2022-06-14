import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/authenticate/login.dart';
import 'package:my_notes/home/addNote.dart';
import 'package:my_notes/home/viewNote.dart';
import 'package:my_notes/models/user_model.dart';
import 'package:my_notes/shared/Laoding.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> cardColors = [
    Colors.cyanAccent[200],
    Colors.yellow[400],
    Colors.redAccent[200],
    Colors.purple[200],
    Colors.pink[200],
    Colors.orangeAccent,
  ];
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    CollectionReference ref = Firestore.instance
        .collection('notes')
        .document(user.uid)
        .collection('individualNotes');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text(
                  'You have no notes created yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                Map data = {
                  'title': snapshot.data.documents[index].data['title'],
                  'content': snapshot.data.documents[index].data['content'],
                };
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewNote(
                        ref: snapshot.data.documents[index].reference,
                        data: data,
                      );
                    })).whenComplete(() {
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 80,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Card(
                      color: cardColors[random.nextInt(4)],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${snapshot.data.documents[index].data['title']}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNote();
          })).whenComplete(() {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
