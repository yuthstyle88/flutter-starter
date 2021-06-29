class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://192.168.1.39:5000";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = "/posts";
  static const String postLogin = '/post_login';
  static const String postSignup = '/post_signup';
  static const String postUpdateUser = '/post_signup';
  static const String getUserInfo = '/users/1';

//static Uri postLogin = Uri.http(baseUrl, "/post_login");
}
