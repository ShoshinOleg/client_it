import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../domain/app_api.dart';
import '../domain/app_config.dart';
import 'auth_interceptor.dart';

@Singleton(as: AppApi)
class DioAppApi implements AppApi {

  late final Dio dio;

  DioAppApi(AppConfig appConfig) {
    final options = BaseOptions(
        baseUrl: appConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15)
    );
    dio = Dio(options);
    if (kDebugMode) dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(AuthInterceptor());
  }

  @override
  Future<Response> getProfile() {
    try {
      return dio.get("/auth/user");
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> passwordUpdate({required String oldPassword, required String newPassword}) {
    // TODO: implement passwordUpdate
    throw UnimplementedError();
  }

  @override
  Future<Response> refreshToken({String? refreshToken}) {
    try {
      return dio.post("/auth/token/$refreshToken");
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> signIn({required String username, required String password}) {
    try {
      return dio.post(
          "/auth/token",
          data: {
            "username": username,
            "password": password
          }
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> signUp({
    required String username,
    required String email,
    required String password
  }) {
    try {
      return dio.put(
          "/auth/token",
          data: {
            "username": username,
            "email": email,
            "password": password
          }
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> userUpdate({String? username, String? email}) {
    // TODO: implement userUpdate
    throw UnimplementedError();
  }

  @override
  Future<dynamic> request(String path, {required data, required queryParameters}) {
    return dio.request(path, data: data, queryParameters: queryParameters);
  }
}