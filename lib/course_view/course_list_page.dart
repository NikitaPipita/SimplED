import 'package:flutter/material.dart';

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
          expandedHeight: 200.0,
          floating: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 10.0),
              child: SearchTextField(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(courses),
        ),
      ],
    );
  }
}


class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  final _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search Course...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90.0),
          borderSide: BorderSide(),
        ),
      ),
      //TODO: Send new request to the server.
      //TODO: Replace course list with new values and set new state.
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        print(_searchController.text);
      },
    );
  }
}