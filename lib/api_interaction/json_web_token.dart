import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class JsonWebToken {
  static String accessToken;
  static String refreshToken;

  static Future<int> passwordAuthentication
      (String email, String password) async {
    var userAuthenticationKey = <String, String> {
      'email' : email,
      'password' : password,
    };

    final response = await http.post(
      'https://simpled-api.herokuapp.com/users/token/',
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userAuthenticationKey),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      accessToken = data['access'];
      refreshToken = data['refresh'];
      print('User is authenticated');
      return data['user_id'];
    } else {
      print('Authentication failed. ' + response.statusCode.toString());
      return null;
    }
  }

  static Future<void> refreshCreate() async {
    var refreshTokenMap = <String, String> {
      'refresh' : refreshToken,
    };
    final response = await http.post(
      'https://simpled-api.herokuapp.com/users/refresh/',
      headers: <String, String> {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(refreshTokenMap),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      accessToken = data['access'];
      refreshToken = data['refresh'];
      print('Json web token refreshed');
    } else {
      throw Exception('Failed to refreshed json web token');
    }
  }
}