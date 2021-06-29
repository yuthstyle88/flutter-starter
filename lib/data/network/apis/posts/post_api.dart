import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:dio/dio.dart';

class PostApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  PostApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<PostList> getPosts() async {
    try {
      final res = await _dioClient.get(Endpoints.getPosts);
      return PostList.fromJson(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<User> postLogin(String email, String password) async {
    try {
      final res = await _restClient.post(Endpoints.postLogin,
          body: convert.jsonEncode({'username': email, 'password': password}),
          headers: {'Content-Type': 'application/json'});
      return User.fromJson(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<User> postSignup(User user) async {
    try {
      var data = convert.jsonEncode(user.toJson());
      print('[Data] = $data');
      final res = await _restClient.post(Endpoints.postSignup,
          body: data, headers: {'Content-Type': 'application/json'});
      return User.fromJson(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
