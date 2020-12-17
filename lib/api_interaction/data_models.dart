class CourseCategory {
  final String dbValue;
  final String title;

  CourseCategory({
    this.dbValue,
    this.title
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
    dbValue: json['db_value'],
    title: json['title'],
  );
}

class CourseLanguage {
  final String dbValue;
  final String title;

  CourseLanguage({
    this.dbValue,
    this.title
  });

  factory CourseLanguage.fromJson(Map<String, dynamic> json) => CourseLanguage(
    dbValue: json['db_value'],
    title: json['title'],
  );
}

class User {
  final int id;
  final String imageUrl;
  final String email;
  final String firstName;
  final String lastName;
  final String biography;
  final int points;

  User({
    this.id,
    this.imageUrl,
    this.email,
    this.firstName,
    this.lastName,
    this.biography,
    this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    imageUrl: json['image'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    biography: json['bio'],
    points: json['points'],
  );
}

class UserCourses {
  final List<Course> userCourses;
  final List<Course> createdCourses;

  UserCourses(
    this.userCourses,
    this.createdCourses,
  );
}

class Course {
  final int id;
  final int creatorId;
  final List<int> participants;
  final String imageUrl;
  final String title;
  final String description;
  final String category;
  final String language;
  final String startDate;
  final bool isActive;

  Course({
    this.id,
    this.creatorId,
    this.participants,
    this.imageUrl,
    this.title,
    this.description,
    this.category,
    this.language,
    this.startDate,
    this.isActive,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var data = json['participants'] as List;
    List<int> participants = data.map((e) => e as int).toList();
    return Course(
      id: json['id'],
      creatorId: json['creator'],
      participants: participants,
      imageUrl: json['image'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      language: json['language'],
      startDate: json['start_date'],
      isActive: json['is_active'],
    );
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final String deadlineDate;
  final String deadlineTime;

  Task({
    this.id,
    this.title,
    this.description,
    this.deadlineDate,
    this.deadlineTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    /// Convert json date String format 2019-08-24T14:15:22Z
    /// into 2019-08-24 and 14:15
    List<String> dateTime = json['deadline'].toString().split('T');
    String date = dateTime[0];
    String time = dateTime[1].substring(0, dateTime[1].length - 4);
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadlineDate: date,
      deadlineTime: time,
    );
  }
}

class TaskAnswer {
  final int id;
  final User owner;
  final String text;
  final String file;
  final String lastModified;
  final int taskId;

  TaskAnswer({
    this.id,
    this.owner,
    this.text,
    this.file,
    this.lastModified,
    this.taskId,
  });

  factory TaskAnswer.fromJson(Map<String, dynamic> json) {
    /// Convert json date String format "2019-08-24T14:15:22Z"
    /// into "2019-08-24 14:15"
    List<String> dateTime = json['last_modified'].toString().split('T');
    String date = dateTime[0];
    List<String> jsonTime = dateTime[1].split(':');
    String time = jsonTime[0] + ':' + jsonTime[1];
    return TaskAnswer(
      id: json['id'],
      owner: User.fromJson(json['owner']),
      text: json['text'],
      file: json['file'],
      lastModified: date + ' ' + time,
      taskId: json['task'],
    );
  }
}