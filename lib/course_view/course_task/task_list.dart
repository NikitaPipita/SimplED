import 'package:flutter/material.dart';

import 'task_creation_page.dart';

enum TaskListViewType {
  creator,
  participant
}

class TaskList extends StatelessWidget {

  final int courseId;
  final TaskListViewType taskListViewType;
  final List<Widget> taskList;

  TaskList(
      this.courseId,
      this.taskListViewType,
      this.taskList);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverVisibility(
          visible: taskListViewType == TaskListViewType.creator ? true : false,
          sliver: SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(
              child: RaisedButton(
                child: Text('+ Create Task'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskCreationPage(courseId)
                      )
                  );
                },
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(taskList),
        ),
      ],
    );
  }
}
