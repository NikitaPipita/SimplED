import 'package:flutter/material.dart';

import 'course_creation_page.dart';
import '../course_view/course_card.dart';

class UserCoursesPage extends StatefulWidget {
  @override
  _UserCoursesPageState createState() => _UserCoursesPageState();
}

class _UserCoursesPageState extends State<UserCoursesPage> with SingleTickerProviderStateMixin {

  final courseList = [
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
  ];

  final coursesTabs = [
    Tab(text: 'My Courses'),
    Tab(text: 'Created Courses'),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: coursesTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: coursesTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(courseList),
              ),
            ],
          ),
          //TODO: Replace with API requests
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: SliverToBoxAdapter(
                  child: RaisedButton(
                    child: Text('+ Create Course'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CourseCreationPage())
                      );
                    },
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(courseList),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
