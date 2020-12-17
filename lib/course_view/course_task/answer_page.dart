import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../../api_interaction/data_models.dart';
import '../../api_interaction/requests.dart';
import 'task_list.dart';

class AnswerPage extends StatefulWidget {
  final TaskListViewType _answerViewType;
  final int _courseId;
  final Task taskInfo;
  final TaskAnswer taskAnswerInfo;

  AnswerPage(
      this._answerViewType, this._courseId,
      {this.taskInfo, this.taskAnswerInfo,});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {

  TextEditingController _textResponse;

  @override
  void initState() {
    super.initState();
    _textResponse = TextEditingController();
  }

  @override
  void dispose() {
    _textResponse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: widget._answerViewType == TaskListViewType.creator
          ? creatorAnswerScaffoldBody()
          : participantAnswerScaffoldBody(),
    );
  }

  Widget creatorAnswerScaffoldBody() {
    _textResponse.text = widget.taskAnswerInfo.text;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answer from '
                + widget.taskAnswerInfo.owner.firstName
                + ' ' + widget.taskAnswerInfo.owner.lastName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Form (
            child: TextFormField(
              controller: _textResponse,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              readOnly: true,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: widget.taskAnswerInfo.file != null ? true : false,
            child: RaisedButton(
              child: widget.taskAnswerInfo.file != null
                  ? Text(widget.taskAnswerInfo.file)
                  : Text(''),
              //TODO: Implement file download.
              onPressed: () {/***/},
            ),
          ),
        ],
      ),
    );
  }

  Widget participantAnswerScaffoldBody() {
    GlobalKey<FormState> responseFormKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answer to the task ' + widget.taskInfo.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Form (
            key: responseFormKey,
            child: TextFormField(
              controller: _textResponse,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your answer',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
//          RaisedButton(
//            child: Text('Pick file'),
//            //TODO: Implement file picker.
//            onPressed: () {/***/},
//          ),
          SizedBox(
            height: 16.0,
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('SEND ANSWER'),
              onPressed: () async {
                if (responseFormKey.currentState.validate()) {
                  await createAnswer(
                      widget._courseId,
                      widget.taskInfo.id,
                      text: _textResponse.text);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}