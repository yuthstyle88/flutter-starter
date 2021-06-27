class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "192.168.1.121:5000";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";
  static Uri postLogin = Uri.http(baseUrl, "/post_login");
  //static Uri postLogin = Uri.http(baseUrl, "/post_login");
}