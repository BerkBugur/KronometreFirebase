import 'package:kronometre/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(Kronometre());

class Kronometre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kronometre Deneme',
      theme:
          ThemeData(primarySwatch: Colors.blue, buttonColor: Colors.blueAccent),
      home: Home(),
    );
  }
}
