import 'package:flutter/material.dart';

import '../api_interection/data_models.dart';
import '../api_interection/preload_info.dart';
import '../user_courses/course_creation_page.dart';
import 'course_page.dart';

enum CourseViewType {
  view,
  enrolled,
  created
}

class CourseCard extends StatelessWidget {
  final Course courseInfo;
  final CourseViewType status;
  final Function userCoursesPageUpdate;

  final courseCardShape = RoundedRectangleBorder
    (borderRadius: BorderRadius.circular(10.0));

  CourseCard(this.courseInfo, this.status, {this.userCoursesPageUpdate});

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
            if (status == CourseViewType.view || status == CourseViewType.enrolled) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursePage())
              );
            } else if (status == CourseViewType.created) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      CourseCreationPage(
                        userCoursesPageUpdate,
                        courseInfo: courseInfo,
                      )
                  )
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseInfo.title,
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
                  PreloadInfo.coursesCategories[courseInfo.category],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  courseInfo.description,
                  maxLines: 4,
                ),
                Flexible(child: Container()),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(courseInfo.startDate),
                    Flexible(child: Container()),
                    Text(PreloadInfo.coursesLanguages[courseInfo.language]),
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
