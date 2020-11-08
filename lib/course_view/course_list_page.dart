import 'package:flutter/material.dart';
import 'package:simpleed/api_interection/preload_info.dart';

import '../api_interection/data_models.dart';
import '../api_interection/requests.dart';
import 'course_card.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {

  Future<List<Course>> _futureCourses;
  bool _isFutureLoaded = false;
  final courses = <Widget>[];

  bool searchAction = false;

  void changeSearchAction() {
    setState(() {
      searchAction = !searchAction;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureCourses = getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!_isFutureLoaded) {
              _isFutureLoaded = true;
              for (Course course in snapshot.data) {
                courses.add(CourseCard(course, CourseViewType.view));
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
          delegate: SliverChildListDelegate(courses),
        ),
      ],
    );
  }
}

class CourseSearch extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length == 0) return buildSuggestions(context);

    Future<List<Course>> searchedCoursesFuture = searchCourses(query);
    final searchedCourses = <Widget>[];
    bool isFutureLoaded = false;

    return FutureBuilder(
      //TODO: Repair reload page after closing course page.
      future: searchedCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!isFutureLoaded) {
            for (Course course in snapshot.data) {
              searchedCourses.add(CourseCard(course, CourseViewType.view));
            }
            isFutureLoaded = true;
          }
          return ListView(
            children: searchedCourses,
          );
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final categories = <String>[];
    query.isEmpty
        ? categories.addAll(PreloadInfo.coursesCategories.values)
        : categories.addAll(PreloadInfo.coursesCategories.values.where((element) =>
        element.toLowerCase().startsWith(query.toLowerCase())).toList());

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: RichText(
          text: TextSpan(
            text: categories[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: categories[index].substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          query = categories[index];
        },
      ),
      itemCount: categories.length,
    );
  }
}