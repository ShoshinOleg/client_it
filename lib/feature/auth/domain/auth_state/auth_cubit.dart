import 'package:client_it/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../repositories/auth_repository.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {

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
    } catch (error) {
      emit(AuthState.error(error));
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
    } catch (error) {
      emit(AuthState.error(error));
    }
  }
}