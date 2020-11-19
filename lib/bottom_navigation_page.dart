import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'api_interection/authorized_user_info.dart';
import 'api_interection/data_models.dart';
import 'api_interection/preload_info.dart';
import 'api_interection/requests.dart';
import 'course_view/course_list_page.dart';
import 'user_courses/user_courses_page.dart';
import 'user_profile/user_profile_page.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  Future _futureCategoriesAndLanguages;

  final bottomNavBarPages = [
    CourseList(),
    UserCoursesPage(),
    ProfilePage(),
  ];

  int _selectedPageIndex;

  void _changePage(int index) {
    if (index == _selectedPageIndex) return;
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    PreloadInfo.loadKeys();
    _futureCategoriesAndLanguages = getCoursesCategoriesAndLanguages();
    _selectedPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: preloadInfoFutureBuilder(),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }

  Widget preloadInfoFutureBuilder() {
    return FutureBuilder(
      future: _futureCategoriesAndLanguages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return bottomNavBarPages[_selectedPageIndex];
        } else if (snapshot.hasError) {
          return Center(
              child: Text("${snapshot.error}")
          );
        }
        return Center(
            child: CircularProgressIndicator()
        );
      },
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Explore",
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
      currentIndex: _selectedPageIndex,
      selectedItemColor: HexColor('#00766c'),
      onTap: _changePage,
    );
  }
}