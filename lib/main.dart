import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/authenticate/login.dart';
import 'package:my_notes/home/home.dart';
import 'package:my_notes/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: users,
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()),
    );
  }
}
