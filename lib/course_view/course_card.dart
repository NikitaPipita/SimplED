import 'package:flutter/material.dart';

import 'course_page.dart';

class CourseCard extends StatelessWidget {
  final courseCardShape = RoundedRectangleBorder
    (borderRadius: BorderRadius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10.0),
      child: Card(
        shape: courseCardShape,
        color: Colors.grey[200],
        child: FlatButton(
          shape: courseCardShape,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoursePage())
            );
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course Title',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Category',
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Course Description',
                  maxLines: 4,
                ),
                Flexible(child: Container()),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text('Date'),
                    Flexible(child: Container()),
                    Text('Language'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
