import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class CourseCreationPage extends StatefulWidget {
  final _courseFormKey = GlobalKey<FormState>();
  final _courseTitleController = TextEditingController();
  final _courseDescriptionController = TextEditingController();

  @override
  _CourseCreationPageState createState() => _CourseCreationPageState();
}

class _CourseCreationPageState extends State<CourseCreationPage> {

  @override
  void dispose() {
    widget._courseTitleController.dispose();
    widget._courseDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new course'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Get photo from the CoursePhoto class.
              CoursePhoto(),
              SizedBox(
                height: 15.0,
              ),
              CourseInfoTextForm(
                widget._courseFormKey,
                widget._courseTitleController,
                widget._courseDescriptionController,
              ),
              SizedBox(
                height: 15.0,
              ),
              //TODO: Get selected category from the CourseCategoryDropdownMenu class.
              Align(
                alignment: Alignment.centerLeft,
                child: CourseCategoryDropdownMenu(),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TODO: Get selected language
                  CourseLanguageDropdownMenu(),
                  //TODO: Get selected date.
                  PickDateButton(),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              createCourseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget createCourseButton() {
    return RaisedButton(
      child: Text('PUBLISH'),
      //TODO: Replace with API update and create.
      onPressed: () {/* ... */},
    );
  }
}


class CoursePhoto extends StatefulWidget {
  @override
  _CoursePhotoState createState() => _CoursePhotoState();
}

class _CoursePhotoState extends State<CoursePhoto> {
  File _image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _image == null
                  ? SvgPicture.asset('assets/course_default_picture.svg')
                  : Image.file(_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                onPressed: getImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CourseInfoTextForm extends StatefulWidget {
  final _courseFormKey;
  final _courseTitleController;
  final _courseDescriptionController;

  CourseInfoTextForm(
      this._courseFormKey,
      this._courseTitleController,
      this._courseDescriptionController);

  @override
  _CourseInfoTextFormState createState() => _CourseInfoTextFormState();
}

class _CourseInfoTextFormState extends State<CourseInfoTextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._courseFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget._courseTitleController,
            decoration: InputDecoration(
              labelText: 'Course Title',
              hintText: 'Type course title',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Exeption";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._courseDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Course Description',
              hintText: 'Write a course description',
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Exeption";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}


class CourseCategoryDropdownMenu extends StatefulWidget {
  @override
  _CourseCategoryDropdownMenuState createState() => _CourseCategoryDropdownMenuState();
}

class _CourseCategoryDropdownMenuState extends State<CourseCategoryDropdownMenu> {

  //TODO: Replace with API value
  final categories = <String>[
    'Music',
    'Photography',
    'Design',
    'Arts',
    'Business',
    'Language learning',
    'Programming',
    'Health',
    'Social science',
    'Engineering',
    'Math',
  ];

  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedCategory,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onChanged: (String newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class PickDateButton extends StatefulWidget {
  @override
  _PickDateButtonState createState() => _PickDateButtonState();
}

class _PickDateButtonState extends State<PickDateButton> {

  DateTime _selectedDate = DateTime.now();

  void changeSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(_selectedDate.year.toString() + '-'
          + _selectedDate.month.toString() + '-'
          + _selectedDate.day.toString()),
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        ).then((date) => changeSelectedDate(date));
      },
    );
  }
}


class CourseLanguageDropdownMenu extends StatefulWidget {
  @override
  _CourseLanguageDropdownMenuState createState() => _CourseLanguageDropdownMenuState();
}

class _CourseLanguageDropdownMenuState extends State<CourseLanguageDropdownMenu> {

  //TODO: Replace with API value
  final categories = <String>[
    'English',
    'Chinese',
    'Spanish',
    'French',
    'Russian',
  ];

  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedCategory,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onChanged: (String newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}