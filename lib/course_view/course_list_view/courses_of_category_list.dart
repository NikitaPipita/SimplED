import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoursesOfCategoryList extends StatelessWidget {
  final String categoryTitle;
  final List<Widget> courses;

  CoursesOfCategoryList(
      this.categoryTitle,
      this.courses);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                categoryTitle,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: courses,
          ),
        ),
      ],
    );
  }
}
