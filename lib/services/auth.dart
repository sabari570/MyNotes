import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/home/home.dart';
import 'package:my_notes/models/user_model.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference notesCollection = Firestore.instance.collection('notes');
void signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult = await auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'email': googleSignInAccount.email
      };
      notesCollection.document(user.uid).get().then((doc) {
        if (doc.exists) {
          //if already a user has logged in
          doc.reference.updateData(userData).whenComplete(() =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Home();
              })));
        } else {
          //If a user is logging in for the first time
          notesCollection.document(user.uid).setData(userData).whenComplete(
              () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Home();
                  })));
        }
      });
    }
  } catch (e) {
    print('Exception is:${e.toString()}');
    print('Sign in not Successfull!!');
  }
}

//Providing a stream of user
Stream<User> get users {
  return auth.onAuthStateChanged
      .map((FirebaseUser user) => (user != null) ? User(uid: user.uid) : null);
}
