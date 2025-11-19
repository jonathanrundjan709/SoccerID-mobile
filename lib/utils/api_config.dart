import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000';
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  static String get registerUrl => '$baseUrl/auth/register/';
  static String get loginUrl => '$baseUrl/auth/login/';
  static String get logoutUrl => '$baseUrl/auth/logout/';
  static String get productListUrl => '$baseUrl/json/';
  static String get myProductListUrl => '$baseUrl/json/user/';
  static String get createProductUrl => '$baseUrl/create-flutter/';
}

