import 'package:flutter/material.dart';

import '../api_interection/data_models.dart';
import '../api_interection/preload_info.dart';
import '../api_interection/requests.dart';
import 'course_card.dart';
import 'course_search.dart';
import 'courses_of_category_list.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {

  Future<Map<String, List<Course>>> _futureCoursesByCategory;
  bool _isFutureLoaded = false;
  final coursesByCategory = <Widget>[];

  bool searchAction = false;

  void changeSearchAction() {
    setState(() {
      searchAction = !searchAction;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureCoursesByCategory = getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _futureCoursesByCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!_isFutureLoaded) {
              _isFutureLoaded = true;
              for (String key in PreloadInfo.coursesCategories.keys) {
                String categoryTitle = PreloadInfo.coursesCategories[key];
                var courses = <Widget>[];
                for (Course course in snapshot.data[key]) {
                  courses.add(CourseCard(course, CourseViewType.view));
                }
                if (courses.isNotEmpty) {
                  coursesByCategory.add(
                      CoursesOfCategoryList(categoryTitle, courses));
                }
              }
            }
            return courseListCustomScrollView();
          } else if (snapshot.hasError) {
            return Center(
                child: Text("${snapshot.error}")
            );
          }
          return Center(
              child: CircularProgressIndicator()
          );
        },
      ),
    );
  }

  Widget courseListCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          automaticallyImplyLeading: false,
          title: Text('Explore'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CourseSearch());
              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(coursesByCategory),
        ),
      ],
    );
  }
}