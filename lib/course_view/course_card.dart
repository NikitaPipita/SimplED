import 'package:flutter/material.dart';

import '../api_interection/data_models.dart';
import '../api_interection/preload_info.dart';
import 'course_page.dart';

enum CourseViewType {
  view,
  searchView,
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
      width: status == CourseViewType.view ? 250 : double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Card(
        shape: courseCardShape,
        color: Colors.grey[200],
        child: FlatButton(
          shape: courseCardShape,
          onPressed: () {
            if (status == CourseViewType.created) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      CoursePage(
                        courseInfo,
                        status,
                        userCoursesPageUpdate: userCoursesPageUpdate,
                      )
                  )
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      CoursePage(courseInfo, status)
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
                  maxLines: status == CourseViewType.view ? 1 : 2,
                  style: TextStyle(
                    fontSize: status == CourseViewType.view ? 16.0 : 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: status == CourseViewType.view ? 0 : 5.0,
                ),
                Visibility(
                  visible: status == CourseViewType.view ? false : true,
                  child: Text(
                    PreloadInfo.coursesCategories[courseInfo.category],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  courseInfo.description,
                  maxLines: status == CourseViewType.view ? 2 : 4,
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
