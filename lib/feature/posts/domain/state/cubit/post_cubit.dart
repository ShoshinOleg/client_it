import 'dart:async';

import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../entity/post/post_entity.dart';


part 'post_state.dart';
part 'post_cubit.freezed.dart';
part 'post_cubit.g.dart';

class PostCubit extends HydratedCubit<PostState> {
  PostCubit(
      this.repository,
      this.authCubit
  ) : super(const PostState(asyncSnapshot: AsyncSnapshot.nothing())) {
    authSubscription = authCubit.stream.listen((event) {
      event.mapOrNull(
        authorized: (value) => fetchPosts(),
        notAuthorized: (value) => logout()
      );
    });
  }

  final PostRepository repository;
  final AuthCubit authCubit;
  late final StreamSubscription authSubscription;

  Future<void> fetchPosts() async {
    emit(state.copyWith(asyncSnapshot: const AsyncSnapshot.waiting()));
    await repository.fetchPosts()
      .then((value) {
        final Iterable iterable = value;
        emit(
          state.copyWith(
            postList: iterable.map((e) => PostEntity.fromJson(e)).toList(),
            asyncSnapshot: const AsyncSnapshot.withData(
              ConnectionState.done,
              true
            )
          )
        );
      })
      .catchError((error) {
        addError(error);
      });
  }

  Future<void> createPost(Map args) async {
    await repository.createPost(args)
        .then((value) {
      fetchPosts();
    })
        .catchError((error) {
      addError(error);
    });
  }

  void logout() {
    emit(
      state.copyWith(
          asyncSnapshot: const AsyncSnapshot.nothing(),
          postList: []
      )
    );
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    emit(
      state.copyWith(
        asyncSnapshot: AsyncSnapshot.withError(ConnectionState.done, error)
      )
    );
    super.addError(error, stackTrace);
  }

  @override
  PostState? fromJson(Map<String, dynamic> json) {
    return PostState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PostState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
