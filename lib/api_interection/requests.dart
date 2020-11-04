import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authorized_user_info.dart';
import 'data_models.dart';
import 'preload_info.dart';

Future<List<CourseCategory>> getCoursesCategories() async {
  final response =
  await http.get('http://simpled-api.herokuapp.com/courses/categories/');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => CourseCategory.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load courses categories');
  }
}

Future<List<CourseLanguage>> getCoursesLanguages() async {
  final response =
  await http.get('http://simpled-api.herokuapp.com/courses/languages/');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => CourseLanguage.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load courses languages');
  }
}

Future<List<Course>> getCourses() async {
  final response =
  await http.get('http://simpled-api.herokuapp.com/courses/');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var courses = <Course>[];
    for (String key in PreloadInfo.coursesCategories.keys) {
      var categoryData = data[key] as List;
      courses.addAll(categoryData.map((e) => Course.fromJson(e)).toList());
    }
    return courses;
  } else {
    throw Exception('Failed to load courses');
  }
}

Future<User> getUserInfo(int id) async {
  final response =
  await http.get('http://simpled-api.herokuapp.com/users/$id');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user info with id $id');
  }
}

Future<UserCourses> getUserCourses() async {
  final response =
  await http.get('http://simpled-api.herokuapp.com/users/${AuthorizedUserInfo.userInfo.id}?nested=true');

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var enrolledCoursesData = data['enrolled_courses'] as List;
    var addedCoursesData = data['added_courses'] as List;
    List<Course> userCourses = enrolledCoursesData.map((e) =>
        Course.fromJson(e)).toList();
    List<Course> createdCourses = addedCoursesData.map((e) =>
        Course.fromJson(e)).toList();

    return UserCourses(userCourses, createdCourses);
  } else {
    throw Exception('Failed to load user courses');
  }
}

Future<void> createCourse(Course course) async {
  var fieldsToPost = <String, String>{};

  fieldsToPost['creator'] = AuthorizedUserInfo.userInfo.id.toString();
  if (course.imageUrl != null) fieldsToPost['image'] = course.imageUrl;
  fieldsToPost['title'] = course.title;
  fieldsToPost['description'] = course.description;
  fieldsToPost['category'] = course.category;
  fieldsToPost['language'] = course.language;
  fieldsToPost['start_date'] = course.startDate;

  final response = await http.post(
    'http://simpled-api.herokuapp.com/courses/',
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //TODO: Implement course image post.
    body: jsonEncode(fieldsToPost),
  );

  if (response.statusCode == 201) {
    print('Course created');
  } else {
    throw Exception('Failed to post course');
  }
}

Future<void> patchUpdateCourseInfo(Course course) async {
  var fieldsToUpdate = <String, String>{};

  fieldsToUpdate['creator'] = AuthorizedUserInfo.userInfo.id.toString();
  if (course.imageUrl != null) fieldsToUpdate['image'] = course.imageUrl;
  fieldsToUpdate['title'] = course.title;
  fieldsToUpdate['description'] = course.description;
  fieldsToUpdate['category'] = course.category;
  fieldsToUpdate['language'] = course.language;
  fieldsToUpdate['start_date'] = course.startDate;

  final response = await http.patch(
    'http://simpled-api.herokuapp.com/courses/${course.id}',
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    //TODO: Implement course image update.
    body: jsonEncode(fieldsToUpdate),
  );

  if (response.statusCode == 200) {
    print('Course id ${course.id} is updated');
  } else {
    throw Exception('Failed to update course id ${course.id}');
  }
}

Future<User> patchUpdateUserInfo
    (int id, {image, firstName, lastName, biography}) async {
  var fieldsToUpdate = <String, String>{};

  if (image != null) fieldsToUpdate['image'] = image;
  if (firstName != null) fieldsToUpdate['first_name'] = firstName;
  if (lastName != null) fieldsToUpdate['last_name'] = lastName;
  if (biography != null) fieldsToUpdate['bio'] = biography;

  final response = await http.patch(
    'http://simpled-api.herokuapp.com/users/$id',
    headers: <String, String>{
        'Content-Type': 'application/json',
    },
    //TODO: Implement profile image update.
    body: jsonEncode(fieldsToUpdate),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to reload user info with id $id');
  }
}

Future<void> deleteCourse(int id) async {
  final response = await http.delete(
    'http://simpled-api.herokuapp.com/courses/$id',
  );

  if (response.statusCode == 204) {
    print('Course id $id is deleted');
  } else {
    throw Exception('Failed to delete course id $id');
  }
}

Future<void> deleteUser(int id) async {
  final response = await http.delete(
    'http://simpled-api.herokuapp.com/users/$id',
  );

  if (response.statusCode == 204) {
    print('User id $id is deleted');
  } else {
    throw Exception('Failed to delete user id $id');
  }
}