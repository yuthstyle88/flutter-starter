import 'dart:async';
import 'dart:convert';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:http/http.dart' as http;

import 'exceptions/network_exceptions.dart';
import 'package:boilerplate/extensions/string_extension.dart';

class RestClient {
  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = JsonDecoder();

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String path) {
    return http.get('${Endpoints.baseUrl}$path'.toUri()!).then(_createResponse);
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(String path,
      {Map<String, String>? headers, body, encoding}) {
    return http
        .post(
          '${Endpoints.baseUrl}$path'.toUri()!,
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  // Put:----------------------------------------------------------------------
  Future<dynamic> put(String path,
      {Map<String, String>? headers, body, encoding}) {
    return http
        .put(
          '${Endpoints.baseUrl}$path'.toUri()!,
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  // Delete:----------------------------------------------------------------------
  Future<dynamic> delete(String path,
      {Map<String, String>? headers, body, encoding}) {
    return http
        .delete(
          '${Endpoints.baseUrl}$path'.toUri()!,
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  // Response:------------------------------------------------------------------
  dynamic _createResponse(http.Response response) {
    final String res = response.body;
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw NetworkException(
          message: 'Error fetching data from server', statusCode: statusCode);
    }

    return _decoder.convert(res);
  }
}
