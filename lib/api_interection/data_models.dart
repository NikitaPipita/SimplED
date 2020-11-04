import 'dart:convert';

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
  final List<User> participants;
  final String imageUrl;
  final String title;
  final String description;
  final String category;
  final String language;
  final String startDate;

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
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var data = json['participants'] as List;
    List<User> participants = data.map((e) => User.fromJson(e)).toList();
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
    );
  }
}