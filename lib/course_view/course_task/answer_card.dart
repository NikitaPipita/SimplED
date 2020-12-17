import 'package:flutter/material.dart';

import '../../api_interaction/data_models.dart';
import 'answer_page.dart';
import 'task_list.dart';

class AnswerCard extends StatelessWidget {
  final int _courseId;
  final TaskAnswer _taskAnswerInfo;

  AnswerCard(
      this._courseId,
      this._taskAnswerInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Card(
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnswerPage(
                        TaskListViewType.creator,
                        _courseId,
                        taskAnswerInfo: _taskAnswerInfo,
                      ),
                )
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _taskAnswerInfo.owner.firstName
                      + ' ' + _taskAnswerInfo.owner.lastName,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Text(
                 'Last modified date: ' + _taskAnswerInfo.lastModified,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
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