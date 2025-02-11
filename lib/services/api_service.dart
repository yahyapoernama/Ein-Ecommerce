import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();
  final _apiUrl = dotenv.env['API_URL'] ?? '';
  String get baseUrl => _apiUrl;

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = 10000; // 10 detik
    _dio.options.receiveTimeout = 20000; // 30 detik
    _dio.options.sendTimeout = 20000; // 30 detik
  }

  Future<Response> register(UserModel userModel) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: userModel.toJson(),
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['user'];
        final appBox = Hive.box('appBox');
        appBox.put('token', token);
        appBox.put('user', user);
      }
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw 'Connection timed out. Please try again.';
      } else if (e.response != null) {
        if (e.response?.data['message'] != null) {
          throw e.response?.data['message'];
        } else if (e.response?.data['errors'] != null) {
          throw e.response?.data['errors'];
        } else {
          throw 'Failed to register. Please try again.';
        }
      } else {
        throw 'Failed to register. Please try again.';
      }
    }
  }

  Future<Response> login(UserModel userModel) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: userModel.toJson(),
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['user'];
        final appBox = Hive.box('appBox');
        appBox.put('token', token);
        appBox.put('user', user);
      }
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw 'Connection timed out. Please try again.';
      } else if (e.response != null) {
        if (e.response?.data['message'] != null) {
          throw e.response?.data['message'];
        } else if (e.response?.data['errors'] != null) {
          throw e.response?.data['errors'];
        } else {
          throw 'Failed to login. Please try again.';
        }
      } else {
        throw 'Failed to login. Please try again.';
      }
    }
  }
}