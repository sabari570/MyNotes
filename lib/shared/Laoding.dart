import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final spinKit = SpinKitFadingCircle(
    color: Colors.white,
    size: 100,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: spinKit,
      ),
    );
  }
}
