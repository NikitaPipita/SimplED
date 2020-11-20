import 'package:flutter/material.dart';
import 'package:simpleed/api_interection/requests.dart';

import '../../api_interection/data_models.dart';
import 'answer_card.dart';
import 'task_creation_page.dart';

class CreatorTaskPage extends StatelessWidget {
  final int courseId;
  final Task taskInfo;

  CreatorTaskPage(
      this.courseId,
      this.taskInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TaskCreationPage(courseId, taskInfo: taskInfo)
                  )
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskInfo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  taskInfo.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Deadline: ' + taskInfo.deadlineDate
                      + ' '+ taskInfo.deadlineTime,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          taskAnswersFutureBuilder(),
        ],
      ),
    );
  }

  Widget taskAnswersFutureBuilder() {
    var taskAnswersList = <Widget>[];
    return FutureBuilder(
      future: getCourseTaskAnswers(courseId, taskInfo.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (TaskAnswer taskAnswer in snapshot.data) {
            taskAnswersList.add(AnswerCard(courseId, taskAnswer));
          }
          return Column(children: taskAnswersList);
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
}
