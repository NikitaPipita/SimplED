import 'package:flutter/material.dart';

import 'course_list_page.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                child: Text('Search Your\n' 'Course'),
                alignment: Alignment.topLeft,
              ),
            ),
            CategoriesScrollingWidget(),
            Column(
              children: [
                Text('OR'),
                RaisedButton(
                  child: Text('VIEW ALL'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CourseList()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CategoriesScrollingWidget extends StatefulWidget {
  @override
  _CategoriesScrollingWidgetState createState() => _CategoriesScrollingWidgetState();
}

class _CategoriesScrollingWidgetState extends State<CategoriesScrollingWidget> {
  final categoryCardShape = RoundedRectangleBorder
    (borderRadius: BorderRadius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GridView.count(
        crossAxisCount: 3,
        scrollDirection: Axis.horizontal,
        childAspectRatio: 1 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
        //TODO: Replace with API request.
        children: List.generate(14, (index) {
          return Container(
            child: Card(
              shape: categoryCardShape,
              color: Colors.red,
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
        }),
      ),
    );
  }
}
