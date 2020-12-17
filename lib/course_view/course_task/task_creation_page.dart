import 'package:flutter/material.dart';

import '../../api_interaction/data_models.dart';
import '../../api_interaction/requests.dart';

class TaskCreationPage extends StatefulWidget {
  final int courseId;
  final Task taskInfo;

  TaskCreationPage(this.courseId, {this.taskInfo});

  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<FormState> _taskFormKey;
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  TextEditingController _deadlineDateController;
  TextEditingController _deadlineTimeController;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _taskFormKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _deadlineDateController = TextEditingController();
    _deadlineTimeController = TextEditingController();

    if (widget.taskInfo != null) {
      _titleController.text = widget.taskInfo.title;
      _descriptionController.text = widget.taskInfo.description;
      _deadlineDateController.text = widget.taskInfo.deadlineDate;
      _deadlineTimeController.text = widget.taskInfo.deadlineTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _deadlineDateController.dispose();
    _deadlineTimeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: widget.taskInfo != null ?
        [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              await deleteTask(widget.courseId, widget.taskInfo.id);
              Navigator.pop(context);
            },
          ),
        ] : [],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TaskTextForm(
              _taskFormKey,
              _titleController,
              _descriptionController
            ),
            SizedBox(
              height: 16.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: PickDateTimeButton(
                _deadlineDateController,
                _deadlineTimeController,
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Visibility(
              visible: widget.taskInfo == null ? true : false,
              child: addTaskRaisedButton(),
            ),
            Visibility(
                visible: widget.taskInfo == null ? false : true,
                child: updateTaskRaisedButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget addTaskRaisedButton() {
    return RaisedButton(
      child: Text('ADD'),
      onPressed: () async {
        if (_taskFormKey.currentState.validate()) {
          await createTask(
            Task(
              title: _titleController.text,
              description: _descriptionController.text,
              deadlineDate: _deadlineDateController.text,
              deadlineTime: _deadlineTimeController.text,
            ),
            widget.courseId,
          );
          Navigator.pop(context);
        }
      },
    );
  }

  Widget updateTaskRaisedButton() {
    return RaisedButton(
      child: Text('UPDATE'),
      onPressed: () async {
        if (_taskFormKey.currentState.validate()) {
          await putUpdateTaskInfo(
              Task(
                id: widget.taskInfo.id,
                title: _titleController.text,
                description: _descriptionController.text,
                deadlineDate: _deadlineDateController.text,
                deadlineTime: _deadlineTimeController.text,
              ),
              widget.courseId,
          );
          Navigator.pop(context);
        }
      },
    );
  }
}


class TaskTextForm extends StatefulWidget {

  final GlobalKey<FormState> _taskFormKey;
  final TextEditingController _titleController;
  final TextEditingController _descriptionController;

  TaskTextForm(
      this._taskFormKey,
      this._titleController,
      this._descriptionController);

  @override
  _TaskTextFormState createState() => _TaskTextFormState();
}

class _TaskTextFormState extends State<TaskTextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._taskFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget._titleController,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: 'Task Title',
              hintText: 'Type task title',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field must not be empty";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Task Description',
              hintText: 'Write a task description',
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field must not be empty";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}


class PickDateTimeButton extends StatefulWidget {
  final TextEditingController _selectedDateController;
  final TextEditingController _selectedTimeController;

  PickDateTimeButton(
      this._selectedDateController,
      this._selectedTimeController);

  @override
  _PickDateTimeButtonState createState() => _PickDateTimeButtonState();
}

class _PickDateTimeButtonState extends State<PickDateTimeButton> {

  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget._selectedDateController.text == null
        || widget._selectedDateController.text == ''
        || widget._selectedTimeController.text == null
        || widget._selectedTimeController.text == '') {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay(hour: 00, minute: 00);
      widget._selectedDateController.text = convertDateToString(_selectedDate);
      widget._selectedTimeController.text = convertTimeToString(_selectedTime);
    } else {
      List<String> yearMonthDay = widget._selectedDateController.text.split('-');
      _selectedDate = DateTime(
          int.parse(yearMonthDay[0]),
          int.parse(yearMonthDay[1]),
          int.parse(yearMonthDay[2]));
      List<String> hoursMinutes = widget
          ._selectedTimeController.text.split(':');
      _selectedTime = TimeOfDay(
          hour: int.parse(hoursMinutes[0]),
          minute: int.parse(hoursMinutes[1]));
    }
  }

  String convertDateToString(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().length < 2
        ? '0' + date.month.toString()
        : date.month.toString();
    String day = date.day.toString().length < 2
        ? '0' + date.day.toString()
        : date.day.toString();
    return year + '-' + month + '-' + day;
  }

  String convertTimeToString(TimeOfDay time) {
    String hour = time.hour.toString().length < 2
        ? '0' + time.hour.toString()
        : time.hour.toString();
    String minute = time.minute.toString().length < 2
        ? '0' + time.minute.toString()
        : time.minute.toString();
    return hour + ':' + minute;
  }

  void changeSelectedDate(DateTime date) {
    setState(() {
      widget._selectedDateController.text = convertDateToString(date);
      _selectedDate = date;
    });
  }

  void changeSelectedTime(TimeOfDay time) {
    setState(() {
      widget._selectedTimeController.text = convertTimeToString(time);
      _selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
          convertDateToString(_selectedDate)
          + ' '
          + convertTimeToString(_selectedTime)
      ),
      onPressed: () async {
        await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        ).then((date) => changeSelectedDate(date));

        await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        ).then((time) => changeSelectedTime(time));
      },
    );
  }
}