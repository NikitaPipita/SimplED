import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'authorization/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: HexColor('#26a69a'),
        primaryColorLight: HexColor('#64d8cb'),
        primaryColorDark: HexColor('#00766c'),
        accentColor: HexColor('#a5d6a7'),
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
