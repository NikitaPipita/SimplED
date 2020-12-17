import 'package:flutter/material.dart';

import '../../api_interaction/data_models.dart';
import '../../api_interaction/preload_info.dart';
import '../../api_interaction/requests.dart';
import '../course_card.dart';

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
              searchedCourses.add(CourseCard(course, CourseViewType.searchView));
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