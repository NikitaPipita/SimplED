import 'package:flutter/material.dart';
import 'package:simpleed/course_view/course_task/creator_task_page.dart';

import '../../api_interaction/data_models.dart';
import 'answer_page.dart';
import 'task_list.dart';

class TaskCard extends StatelessWidget {
  final int courseId;
  final TaskListViewType taskViewType;
  final Task taskInfo;

  TaskCard(
      this.courseId,
      this.taskViewType,
      this.taskInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: FlatButton(
          onPressed: () {
            if (taskViewType == TaskListViewType.creator) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreatorTaskPage(courseId, taskInfo)
                  )
              );
            } else if (taskViewType == TaskListViewType.participant) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AnswerPage(
                            taskViewType,
                            courseId,
                            taskInfo: taskInfo,
                          ),
                  )
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskInfo.title,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  taskInfo.description,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.normal
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Deadline: ' + taskInfo.deadlineDate +
                        ' ' + taskInfo.deadlineTime
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
