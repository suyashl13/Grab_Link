import 'package:Grab_Link/screens/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grab Link',
      theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Gilroy"),
      home: HomePage(),
    );   
  }
}
