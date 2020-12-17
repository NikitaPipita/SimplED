import 'dart:convert';

import 'package:flutter/services.dart';

class PreloadInfo {
  static final cloudUrl = 'https://res.cloudinary.com/';
  static final cloudName = 'hgrb5wnzc';
  static String apiKey;
  static String apiSecret;

  static var coursesCategories = <String, String>{};
  static var coursesLanguages = <String, String>{};

  static void loadKeys() async {
    String jsonString = await rootBundle.loadString('assets/keys.json');
    final keys = json.decode(jsonString);
    apiKey = keys['api_key'];
    apiSecret = keys['api_secret'];
  }
}