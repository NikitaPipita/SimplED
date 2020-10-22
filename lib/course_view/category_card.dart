import 'package:flutter/material.dart';

import 'course_list_page.dart';

class CategoryCard extends StatelessWidget {
  final categoryCardShape = RoundedRectangleBorder
    (borderRadius: BorderRadius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: categoryCardShape,
        color: Colors.orange[200],
        child: FlatButton(
          shape: categoryCardShape,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseList()),
            );
          },
          child: Center(
            child: Text('Category'),
          ),
        ),
      ),
    );
  }
}
