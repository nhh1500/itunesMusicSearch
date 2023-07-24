import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:itunes_music/services/statusCode.dart';

import '../utility/alertMessageBox.dart';

/// controller to request http post / get / put / delete
class ApiHandler {
  static Future<dynamic> postAPI(String url, dynamic data) async {
    if (data is Map<String, dynamic>) {
      data = jsonEncode(data);
    } else if (data is FormData) {}
    try {
      var response = await Dio().post(url,
          data: data,
          options: Options(sendTimeout: const Duration(seconds: 5)));
      if (response.data == "Connection timed out") {
        return AlertMessageBox.show('Timeout', '');
      }
      return response.data;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          AlertMessageBox.show(
              '${e.response?.statusCode} - ${StatusCode.getName(e.response?.statusCode ?? 0)}',
              StatusCode.getDesc(e.response?.statusCode ?? 0).toString());
        }
        if (e.error is SocketException) {
          return (e.error as SocketException).message;
        }
      }
      return {"status": "Uncaught Error"};
    }
  }

  static Future<dynamic> getAPI(String url) async {
    try {
      var response = await Dio()
          .get(url, options: Options(sendTimeout: const Duration(seconds: 5)));
      if (response.data == "Connection timed out") {
        return AlertMessageBox.show('Timeout', '');
      }
      return response.data;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          AlertMessageBox.show(
              '${e.response?.statusCode} - ${StatusCode.getName(e.response?.statusCode ?? 0)}',
              StatusCode.getDesc(e.response?.statusCode ?? 0).toString());
        }
        if (e.error is SocketException) {
          return (e.error as SocketException).message;
        }
      }
      return {"status": "Uncaught Error"};
    }
  }

  static Future<dynamic> putAPI(String url, dynamic data) async {
    if (data is Map<String, dynamic>) {
      data = jsonEncode(data);
    } else if (data is FormData) {}
    try {
      var response = await Dio().put(url, data: data, options: Options());
      return response.data;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          AlertMessageBox.show(
              '${e.response?.statusCode} - ${StatusCode.getName(e.response?.statusCode ?? 0)}',
              StatusCode.getDesc(e.response?.statusCode ?? 0).toString());
        }
        if (e.error is SocketException) {
          return (e.error as SocketException).message;
        }
      }
      return {"status": "Uncaught Error"};
    }
  }

  static Future<dynamic> deleteAPI(String url, dynamic data) async {
    if (data is Map<String, dynamic>) {
      data = jsonEncode(data);
    } else if (data is FormData) {}
    try {
      var response = await Dio().delete(url, data: data);
      return response.data;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          AlertMessageBox.show(
              '${e.response?.statusCode} - ${StatusCode.getName(e.response?.statusCode ?? 0)}',
              StatusCode.getDesc(e.response?.statusCode ?? 0).toString());
        }
        if (e.error is SocketException) {
          return (e.error as SocketException).message;
        }
      }
      return {"status": "Uncaught Error"};
    }
  }
}
