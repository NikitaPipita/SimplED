import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api_interection/data_models.dart';
import '../api_interection/preload_info.dart';

enum HttpRequestType {
  create,
  update,
  delete
}

class CourseCreationPage extends StatefulWidget {
  final Function userCoursesPageUpdate;
  final Course courseInfo;

  CourseCreationPage(
      this.userCoursesPageUpdate,
      {Key key, this.courseInfo}
      ) : super(key: key);

  @override
  _CourseCreationPageState createState() => _CourseCreationPageState();
}

class _CourseCreationPageState extends State<CourseCreationPage> {

  CloudinaryClient _cloudinary;
  File _image;
  getPhotoFileFromTheChild(File value) => _image = value;

  GlobalKey<FormState> _courseFormKey;
  TextEditingController _courseTitleController;
  TextEditingController _courseDescriptionController;
  TextEditingController _courseCategoryController;
  TextEditingController _courseLanguageController;
  TextEditingController _courseDateController;

  @override
  void initState() {
    super.initState();

    _cloudinary = CloudinaryClient(
        PreloadInfo.apiKey,
        PreloadInfo.apiSecret,
        PreloadInfo.cloudName);

    _courseFormKey = GlobalKey<FormState>();
    _courseTitleController = TextEditingController();
    _courseDescriptionController = TextEditingController();
    _courseCategoryController = TextEditingController();
    _courseLanguageController = TextEditingController();
    _courseDateController = TextEditingController();

    if (widget.courseInfo != null) {
      _courseTitleController.text = widget.courseInfo.title;
      _courseDescriptionController.text = widget.courseInfo.description;
      _courseCategoryController.text = PreloadInfo.coursesCategories[widget.courseInfo.category];
      _courseLanguageController.text = PreloadInfo.coursesLanguages[widget.courseInfo.language];
      _courseDateController.text = widget.courseInfo.startDate;
    }
  }

  @override
  void dispose() {
    _courseTitleController.dispose();
    _courseDescriptionController.dispose();
    _courseCategoryController.dispose();
    _courseLanguageController.dispose();
    _courseDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new course'),
        actions: widget.courseInfo != null
            ? [
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  Course course = Course(id: widget.courseInfo.id);
                  widget.userCoursesPageUpdate(course, HttpRequestType.delete);
                  Navigator.pop(context);
                },
              ),]
            : [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CoursePhoto(
                getPhotoFileFromTheChild,
                widget.courseInfo != null ? widget.courseInfo.imageUrl : null
              ),
              SizedBox(
                height: 15.0,
              ),
              CourseInfoTextForm(
                _courseFormKey,
                _courseTitleController,
                _courseDescriptionController,
              ),
              SizedBox(
                height: 15.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CourseDropdownMenu(
                    PreloadInfo.coursesCategories.values.toList(),
                    _courseCategoryController,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CourseDropdownMenu(
                      PreloadInfo.coursesLanguages.values.toList(),
                      _courseLanguageController
                  ),
                  PickDateButton(_courseDateController),
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
      child: widget.courseInfo == null ? Text('PUBLISH') : Text('UPDATE'),
      onPressed: () async {
        if (_courseFormKey.currentState.validate()) {

          String category;
          for (String key in PreloadInfo.coursesCategories.keys) {
            if (_courseCategoryController.text == PreloadInfo.coursesCategories[key]) {
              category = key;
              break;
            }
          }

          String language;
          for (String key in PreloadInfo.coursesLanguages.keys) {
            if (_courseLanguageController.text == PreloadInfo.coursesLanguages[key]) {
              language = key;
              break;
            }
          }

          String imageUrl;
          if (_image != null) {
            var response = await _cloudinary.uploadImage(_image.path, folder: 'course_pics');
            imageUrl = 'v' + response.version.toString() +
                '/' + response.public_id +
                '.' + response.format;
          }

          if (widget.courseInfo == null) {
            Course course = Course(
              imageUrl: imageUrl,
              title: _courseTitleController.text,
              description: _courseDescriptionController.text,
              category: category,
              language: language,
              startDate: _courseDateController.text,
            );
            widget.userCoursesPageUpdate(course, HttpRequestType.create);
          } else {
            Course course = Course(
              id: widget.courseInfo.id,
              imageUrl: imageUrl,
              title: _courseTitleController.text,
              description: _courseDescriptionController.text,
              category: category,
              language: language,
              startDate: _courseDateController.text,
            );
            widget.userCoursesPageUpdate(course, HttpRequestType.update);
          }

          Navigator.pop(context);
        }
      },
    );
  }
}


class CoursePhoto extends StatefulWidget {
  final Function sendPhotoFileToTheParent;
  final courseImageUrl;

  CoursePhoto(
      this.sendPhotoFileToTheParent,
      this.courseImageUrl,);

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
        widget.sendPhotoFileToTheParent(_image);
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
                  ? widget.courseImageUrl != null
                    ? Image.network(PreloadInfo.cloudUrl + PreloadInfo.cloudName + '/' + widget.courseImageUrl)
                    : SvgPicture.asset('assets/course_default_picture.svg')
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
            maxLength: 100,
            decoration: InputDecoration(
              labelText: 'Course Title',
              hintText: 'Type course title',
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
            controller: widget._courseDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Course Description',
              hintText: 'Write a course description',
              prefixIcon: Icon(Icons.description),
            ),
          ),
        ],
      ),
    );
  }
}


class CourseDropdownMenu extends StatefulWidget {
  final List<String> _dropdownMenuItems;
  final _dropdownMenuValueController;

  CourseDropdownMenu(
      this._dropdownMenuItems,
      this._dropdownMenuValueController);

  @override
  _CourseDropdownMenuState createState() => _CourseDropdownMenuState();
}

class _CourseDropdownMenuState extends State<CourseDropdownMenu> {

  @override
  void initState() {
    super.initState();
    if (widget._dropdownMenuValueController.text == null
        || widget._dropdownMenuValueController.text == '') {
      widget._dropdownMenuValueController.text = widget._dropdownMenuItems[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget._dropdownMenuValueController.text,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onChanged: (String newValue) {
        setState(() {
          widget._dropdownMenuValueController.text = newValue;
        });
      },
      items: widget._dropdownMenuItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class PickDateButton extends StatefulWidget {
  final _selectedDateController;

  PickDateButton(this._selectedDateController);

  @override
  _PickDateButtonState createState() => _PickDateButtonState();
}

class _PickDateButtonState extends State<PickDateButton> {

  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget._selectedDateController.text == null
        || widget._selectedDateController.text == '') {
      widget._selectedDateController.text = convertDateToString(DateTime.now());
      _selectedDate = DateTime.now();
    } else {
      List<String> yearMonthDay = widget._selectedDateController.text.split('-');
      _selectedDate = DateTime(
          int.parse(yearMonthDay[0]),
          int.parse(yearMonthDay[1]),
          int.parse(yearMonthDay[2]));
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

  void changeSelectedDate(DateTime date) {
    setState(() {
      widget._selectedDateController.text = convertDateToString(date);
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(convertDateToString(_selectedDate)),
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