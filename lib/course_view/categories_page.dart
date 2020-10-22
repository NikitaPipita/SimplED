import 'package:flutter/material.dart';

import 'category_card.dart';
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
                child: Text(
                  'Search Your\n' 'Course',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            CategoriesScrollingWidget(),
            Column(
              children: [
                Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 50.0,
                  width: 300.0,
                  child: RaisedButton(
                    child: Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontSize: 19.0
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CourseList()),
                      );
                    },
                  ),
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

  final categoriesList = <Widget>[
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
    CategoryCard(),
  ];

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
        children: categoriesList,
      ),
    );
  }
}
