import 'package:client_it/app/domain/app_api.dart';
import 'package:client_it/feature/auth/data/dto/user_dto.dart';
import 'package:client_it/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:client_it/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
@prod
class NetworkAuthRepository implements AuthRepository {
  final AppApi api;

  NetworkAuthRepository(this.api);

  @override
  Future<UserEntity> getProfile() async {
    try {
      final response = await api.getProfile();
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> passwordUpdate({
    required String oldPassword,
    required String newPassword
  }) async {
    try {
      final Response response = await api.passwordUpdate(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return response.data["message"];
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> refreshToken({String? refreshToken}) async {
    try {
      final response = await api.refreshToken(refreshToken: refreshToken);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signIn({
    required String username,
    required String password
  }) async {
    try {
      final response = await api.signIn(username: username, password: password);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password
  }) async {
    try {
      final response = await api.signUp(
          username: username,
          email: email,
          password: password
      );
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future userUpdate({String? username, String? email}) async {
    try {
      final response = await api.userUpdate(
          username: username,
          email: email,
      );
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }
}