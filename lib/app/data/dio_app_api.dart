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
    if (kDebugMode) {
      dio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true
          )
      );
    }
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
    try {
      return dio.put(
          "/auth/user",
          data: {
            "oldPassword": oldPassword,
            "newPassword": newPassword,
          }
      );
    } catch (_) {
      rethrow;
    }
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
    try {
      return dio.post(
          "/auth/user",
          data: {
            "username": username,
            "email": email,
          }
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future fetch(RequestOptions requestOptions) {
    return dio.fetch(requestOptions);
  }

  @override
  Future fetchPosts() {
    return dio.get("/data/posts");
  }

  @override
  Future createPost(Map args) {
    return dio.post(
      "/data/posts",
      data: {
        "name": args["name"],
        "content": args["content"]
      }
    );
  }

  @override
  Future fetchPost(String id) {
    return dio.get("/data/posts/$id");
  }
}