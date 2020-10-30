import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'course_view/categories_page.dart';
import 'user_courses/user_courses_page.dart';
import 'user_profile/user_profile_page.dart';

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
      home: BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  final bottomNavBarPages = [
    CategoriesPage(),
    UserCoursesPage(),
    ProfilePage(),
  ];

  int _selectedPage = 0;

  void _changePage(int index) {
    if (index == _selectedPage) return;
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomNavBarPages[_selectedPage],
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Courses",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        ),
      ],
      currentIndex: _selectedPage,
      selectedItemColor: HexColor('#00766c'),
      onTap: _changePage,
    );
  }
}

