import 'package:client_it/app/domain/error_entity/error_entity.dart';
import 'package:client_it/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';
part 'auth_cubit.g.dart';

@Singleton(order: 1)
class AuthCubit extends HydratedCubit<AuthState> {

  AuthCubit(this.authRepository): super(const AuthState.notAuthorized());

  final AuthRepository authRepository;

  Future<void> signIn({
    required String username,
    required String password
  }) async {
    emit(const AuthState.waiting());
    try {
      final UserEntity userEntity = await authRepository.signIn(
          username: username,
          password: password
      );
      emit(AuthState.authorized(userEntity));
    } catch (error, st) {
      addError(error, st);
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password
  }) async {
    emit(const AuthState.waiting());
    try {
      final UserEntity userEntity = await authRepository.signUp(
          username: username,
          email: email,
          password: password
      );
      emit(AuthState.authorized(userEntity));
    } catch (error, st) {
      addError(error, st);
    }
  }

  Future<String?> refreshToken() async {
    final refreshToken =
      state.whenOrNull(authorized: (userEntity) => userEntity.refreshToken);
    try {
      final userEntity = await authRepository
          .refreshToken(refreshToken: refreshToken);
      emit(AuthState.authorized(userEntity));
      return userEntity.accessToken;
    } catch (error, st) {
      addError(error, st);
    }
    return null;
  }

  Future<void> getProfile() async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      final UserEntity newUserEntity = await authRepository.getProfile();
      emit(
          state.maybeWhen(
            orElse: () => state,
            authorized: (userEntity) => AuthState.authorized(
                userEntity.copyWith(
                  email: newUserEntity.email,
                  username: newUserEntity.username
                )
            )
          )
      );
      _updateUserState(
          const AsyncSnapshot.withData(
              ConnectionState.done,
              "Успешное получение данных"
          )
      );
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

  Future<void> userUpdate({
    String? email,
    String? username
  }) async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      Future.delayed(const Duration(seconds: 1));
      final isEmptyEmail = email?.trim().isEmpty ?? false;
      final isEmptyUsername = username?.trim().isEmpty ?? false;

      final UserEntity newUserEntity = await authRepository.userUpdate(
        email: isEmptyEmail ? null : email,
        username: isEmptyUsername ? null : username,
      );
      emit(
          state.maybeWhen(
              orElse: () => state,
              authorized: (userEntity) => AuthState.authorized(
                  userEntity.copyWith(
                      email: newUserEntity.email,
                      username: newUserEntity.username
                  )
              )
          )
      );
      _updateUserState(
          const AsyncSnapshot.withData(
              ConnectionState.done,
              "Успешная операция"
          )
      );
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

  Future<void> passwordUpdate({
    required String oldPassword,
    required String newPassword
  }) async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      Future.delayed(const Duration(seconds: 1));

      if (newPassword.trim().isEmpty == true) {
        throw ErrorEntity(message: "Новый пароль не может быть пустым");
      }

      final message = await authRepository.passwordUpdate(
        oldPassword: oldPassword,
        newPassword: newPassword
      );
      _updateUserState(AsyncSnapshot.withData(ConnectionState.done, message));
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

  void logout() => emit(const AuthState.notAuthorized());

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final state = AuthState.fromJson(json);
    return state.whenOrNull(
      authorized: (userEntity) => AuthState.authorized(userEntity)
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.whenOrNull(
      authorized: (userEntity) => AuthState.authorized(userEntity)
    )?.toJson() ?? const AuthState.notAuthorized().toJson();
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    emit(AuthState.error(error));
    super.addError(error, stackTrace);
  }

  void _updateUserState(AsyncSnapshot asyncSnapshot) {
    emit(
        state.maybeWhen(
            orElse: () => state,
            authorized: (userEntity) {
              return AuthState.authorized(
                  userEntity.copyWith(userState: asyncSnapshot)
              );
            }
        )
    );
  }
}