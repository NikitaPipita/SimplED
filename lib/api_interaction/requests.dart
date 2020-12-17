import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authorized_user_info.dart';
import 'data_models.dart';
import 'json_web_token.dart';
import 'preload_info.dart';

Future<bool> getCoursesCategoriesAndLanguages() async {
  List<CourseCategory> categories = await getCoursesCategories();
  for (CourseCategory category in categories) {
    PreloadInfo.coursesCategories[category.dbValue] = category.title;
  }

  List<CourseLanguage> languages = await getCoursesLanguages();
  for (CourseLanguage language in languages) {
    PreloadInfo.coursesLanguages[language.dbValue] = language.title;
  }
  return true;
}

Future<List<CourseCategory>> getCoursesCategories() async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/categories/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<CourseCategory> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => CourseCategory.fromJson(e)).toList();
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load courses categories');
    }
  }
}

Future<List<CourseLanguage>> getCoursesLanguages() async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/languages/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<CourseLanguage> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => CourseLanguage.fromJson(e)).toList();
  }


  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load courses languages');
    }
  }
}

Future<Map<String, List<Course>>> getCourses() async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  Map<String, List<Course>> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body);
    var coursesByCategory = <String, List<Course>>{};
    for (String key in PreloadInfo.coursesCategories.keys) {
      var categoryData = data[key] as List;
      var courses = <Course>[];
      courses.addAll(categoryData.map((e) => Course.fromJson(e)).toList());
      coursesByCategory[key] = courses;
    }
    return coursesByCategory;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}

Future<List<Course>> searchCourses(String query) async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses?search=$query',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<Course> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e)).toList();
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load searched courses');
    }
  }
}

Future<User> getUserInfo(int id) async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/users/$id/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  User decodeResponse(http.Response response) {
    return User.fromJson(jsonDecode(response.body));
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load user info with id $id');
    }
  }
}

Future<UserCourses> getUserCourses() async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/users/${AuthorizedUserInfo.userInfo.id}?nested=true',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  UserCourses decodeResponse(http.Response response) {
    var data = jsonDecode(response.body);
    var enrolledCoursesData = data['enrolled_courses'] as List;
    var addedCoursesData = data['added_courses'] as List;
    List<Course> userCourses = enrolledCoursesData.map((e) =>
        Course.fromJson(e)).toList();
    List<Course> createdCourses = addedCoursesData.map((e) =>
        Course.fromJson(e)).toList();

    return UserCourses(userCourses, createdCourses);
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load user courses');
    }
  }
}

Future<List<Task>> getCourseTasks(int courseId) async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/$courseId/tasks/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<Task> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => Task.fromJson(e)).toList();
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load course id $courseId tasks');
    }
  }
}

Future<List<TaskAnswer>> getCourseTaskAnswers(int courseId, int taskId) async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/$courseId/tasks/$taskId/solutions/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<TaskAnswer> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => TaskAnswer.fromJson(e)).toList();
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load course id $courseId task id $taskId answers');
    }
  }
}

Future<void> createCourse(Course course) async {
  getResponse() async {
    var fieldsToPost = <String, String>{};

    if (course.imageUrl != null) fieldsToPost['image'] = course.imageUrl;
    fieldsToPost['title'] = course.title;
    fieldsToPost['description'] = course.description;
    fieldsToPost['category'] = course.category;
    fieldsToPost['language'] = course.language;
    fieldsToPost['start_date'] = course.startDate;

    final response = await http.post(
        'https://simpled-api.herokuapp.com/courses/',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        },
        body: jsonEncode(fieldsToPost),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 201) {
    print('Course created');
  } else {
    ///TODO: Delete print(data)
    var data = jsonDecode(response.body);
    print(data);
    await JsonWebToken.refreshCreate();
    final secondResponse = await getResponse();
    if (secondResponse.statusCode == 201) {
      print('Course created');
    } else {
      var data = jsonDecode(secondResponse.body);
      print(data);
      throw Exception('Failed to post course');
    }
  }
}

Future<User> createUser(User user, String password) async {
  var createUserInfo = <String, String> {
    'email' : user.email,
    'first_name' : user.firstName,
    'last_name' : user.lastName,
    'password' : password,
    'confirm_password' : password,
  };

  final response = await http.post(
    'https://simpled-api.herokuapp.com/users/',
    headers: <String, String> {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(createUserInfo),
  );

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create user');
  }
}

Future<void> createTask(Task task, int courseId) async {
  getResponse() async {
    var fieldsToPost = <String, String>{};

    /// Convert to json date String format 2019-08-24T14:15:00Z
    /// from 2019-08-24 and 14:15
    fieldsToPost['title'] = task.title;
    fieldsToPost['description'] = task.description;
    fieldsToPost['deadline'] = task.deadlineDate + 'T'
        + task.deadlineTime + ':00Z';
    fieldsToPost['course'] = courseId.toString();

    final response = await http.post(
      'https://simpled-api.herokuapp.com/courses/$courseId/tasks/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(fieldsToPost),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 201) {
    print('Task created in course id $courseId');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 201) {
      print('Task created in course id $courseId');
    } else {
      throw Exception('Failed to create task in course id $courseId');
    }
  }
}

Future<void> createAnswer
    (int courseId, int taskId, {String text, String fileUrl}) async {
  getResponse() async {
    var fieldsToPost = <String, String>{};

    if (text != null) fieldsToPost['text'] = text;
    if (fileUrl != null) fieldsToPost['file'] = fileUrl;

    final response = await http.post(
      'https://simpled-api.herokuapp.com/courses/$courseId/tasks/$taskId/solutions/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(fieldsToPost),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 201) {
    print('Answer on task id $taskId of course id $courseId created');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 201) {
      print('Answer on task id $taskId of course id $courseId created');
    } else {
      throw Exception('Failed to create answer on task id $taskId of course id $courseId');
    }
  }
}

Future<void> putUpdateTaskInfo(Task task, int courseId) async {
  getResponse() async {
    var fieldsToUpdate = <String, String>{};

    /// Convert to json date String format 2019-08-24T14:15:00Z
    /// from 2019-08-24 and 14:15
    fieldsToUpdate['title'] = task.title;
    fieldsToUpdate['description'] = task.description;
    fieldsToUpdate['deadline'] = task.deadlineDate + 'T'
        + task.deadlineTime + ':00Z';
    fieldsToUpdate['course'] = courseId.toString();

    final response = await http.put(
      'https://simpled-api.herokuapp.com/courses/$courseId/tasks/${task.id}/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(fieldsToUpdate),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    print('Task id ${task.id} of course id $courseId is updated');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      print('Task id ${task.id} of course id $courseId is updated');
    } else {
      throw Exception('Failed to update task id ${task.id} of course id $courseId');
    }
  }
}

Future<void> patchUpdateCourseInfo(Course course) async {
  getResponse() async {
    var fieldsToUpdate = <String, String>{};

    if (course.imageUrl != null) fieldsToUpdate['image'] = course.imageUrl;
    fieldsToUpdate['title'] = course.title;
    fieldsToUpdate['description'] = course.description;
    fieldsToUpdate['category'] = course.category;
    fieldsToUpdate['language'] = course.language;
    fieldsToUpdate['start_date'] = course.startDate;

    final response = await http.patch(
      'https://simpled-api.herokuapp.com/courses/${course.id}/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(fieldsToUpdate),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    print('Course id ${course.id} is updated');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      print('Course id ${course.id} is updated');
    } else {
      throw Exception('Failed to update course id ${course.id}');
    }
  }
}

Future<User> patchUpdateUserInfo
    (int id, {image, firstName, lastName, biography}) async {

  getResponse() async {
    var fieldsToUpdate = <String, String>{};

    if (image != null) fieldsToUpdate['image'] = image;
    if (firstName != null) fieldsToUpdate['first_name'] = firstName;
    if (lastName != null) fieldsToUpdate['last_name'] = lastName;
    if (biography != null) fieldsToUpdate['bio'] = biography;

    final response = await http.patch(
        'https://simpled-api.herokuapp.com/users/$id/',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        },
        body: jsonEncode(fieldsToUpdate),
    );
    return response;
  }

  User decodeResponse(http.Response response) {
    return User.fromJson(jsonDecode(response.body));
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to reload user info with id $id. ${response.statusCode}.');
    }
  }
}

Future<void> deleteCourse(int id) async {
  getResponse() async {
    final response = await http.delete(
      'https://simpled-api.herokuapp.com/courses/$id/',
      headers: <String, String> {
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 204) {
    print('Course id $id is deleted');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 204) {
      print('Course id $id is deleted');
    } else {
      throw Exception('Failed to delete course id $id');
    }
  }
}

Future<void> deleteUser(int id) async {
  getResponse() async {
    final response = await http.delete(
      'https://simpled-api.herokuapp.com/users/$id/',
      headers: <String, String> {
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 204) {
    print('User id $id is deleted');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 204) {
      print('User id $id is deleted');
    } else {
      throw Exception('Failed to delete user id $id');
    }
  }
}

Future<void> deleteTask(int courseId, int taskId) async {
  getResponse() async {
    final response = await http.delete(
      'https://simpled-api.herokuapp.com/courses/$courseId/tasks/$taskId/',
      headers: <String, String> {
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 204) {
    print('Task id $taskId is deleted from course id $courseId');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 204) {
      print('Task id $taskId is deleted from course id $courseId');
    } else {
      throw Exception('Failed to delete task id $taskId from course id $courseId');
    }
  }
}

Future<void> enrollInCourse(Course course, int userId) async {
  getResponse() async {

    var participants = course.participants;
    if (!participants.contains(userId)) {
      participants.add(userId);
    }
    var fieldsToUpdate = <String, List<int>>{};

    fieldsToUpdate['participants'] = participants;

    final response = await http.patch(
      'https://simpled-api.herokuapp.com/courses/${course.id}/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(fieldsToUpdate),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    print('Course id ${course.id} participants is updated');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      print('Course id ${course.id} participants is updated');
    } else {
      throw Exception('Failed to update participants course id ${course.id}');
    }
  }
}

Future<void> archiveCourse(Course course) async {
  getResponse() async {
    final response = await http.patch(
      'https://simpled-api.herokuapp.com/courses/${course.id}/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(<String, dynamic> {
        'is_active' : false,
      }),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    print('Course id ${course.id} is archived');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      print('Course id ${course.id} is archived');
    } else {
      throw Exception('Failed to archive course id ${course.id}');
    }
  }
}

Future<void> unarchiveCourse(Course course) async {
  getResponse() async {
    final response = await http.patch(
      'https://simpled-api.herokuapp.com/courses/${course.id}/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
      },
      body: jsonEncode(<String, dynamic> {
        'is_active' : true,
      }),
    );
    return response;
  }

  final response = await getResponse();
  if (response.statusCode == 200) {
    print('Course id ${course.id} is unarchived');
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      print('Course id ${course.id} is unarchived');
    } else {
      throw Exception('Failed to unarchive course id ${course.id}');
    }
  }
}

Future<List<User>> getCourseParticipants(int courseId) async {
  getResponse() async {
    final response = await http.get(
        'https://simpled-api.herokuapp.com/courses/$courseId/participants/',
        headers: <String, String> {
          'Authorization' : 'Bearer ' + JsonWebToken.accessToken,
        }
    );
    return response;
  }

  List<User> decodeResponse(http.Response response) {
    var data = jsonDecode(response.body) as List;
    return data.map((e) => User.fromJson(e)).toList();
  }


  final response = await getResponse();
  if (response.statusCode == 200) {
    return decodeResponse(response);
  } else {
    await JsonWebToken.refreshCreate();
    final response = await getResponse();
    if (response.statusCode == 200) {
      return decodeResponse(response);
    } else {
      throw Exception('Failed to load course ud $courseId participants.');
    }
  }
}