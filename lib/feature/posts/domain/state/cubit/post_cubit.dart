import 'dart:async';

import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../entity/post/post_entity.dart';


part 'post_state.dart';
part 'post_event.dart';
part 'post_cubit.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(
      this.repository,
      this.authCubit
  ) : super(const PostState(asyncSnapshot: AsyncSnapshot.nothing())) {
    authSubscription = authCubit.stream.listen((event) {
      event.mapOrNull(
        authorized: (value) => add(PostEvent.fetch()),
        notAuthorized: (value) => add(PostEvent.logout())
      );
    });

    on<_PostEventFetch>(fetchPosts);
    on<_PostEventCreatePost>(createPost);
    on<_PostEventLogout>(logout);
  }

  final PostRepository repository;
  final AuthCubit authCubit;
  late final StreamSubscription authSubscription;

  Future<void> fetchPosts(PostEvent event, Emitter emitter) async {
    if (state.asyncSnapshot?.connectionState == ConnectionState.waiting) return;
    emitter(state.copyWith(asyncSnapshot: const AsyncSnapshot.waiting()));
    await repository.fetchPosts(state.fetchLimit, state.offset)
      .then((value) {
        final Iterable iterable = value;
        final fetchedList =
          iterable.map((e) => PostEntity.fromJson(e)).toList();
        final mergedList = [...state.postList, ...fetchedList];

        emitter(
          state.copyWith(
            offset: state.offset + fetchedList.length,
            postList: mergedList,
            asyncSnapshot: const AsyncSnapshot.withData(
              ConnectionState.done,
              true
            )
          )
        );
      })
      .catchError((error) {
        stateError(error, emitter);
      });
  }

  Future<void> createPost(PostEvent event, Emitter emitter) async {
    await repository.createPost((event as _PostEventCreatePost).args)
        .then((value) {
      add(PostEvent.fetch());
    }).catchError((error) {
      stateError(error, emitter);
    });
  }

  void logout(PostEvent event, Emitter emitter) async {
    emitter(
      state.copyWith(
          asyncSnapshot: const AsyncSnapshot.nothing(),
          postList: []
      )
    );
  }

  void stateError(Object error, Emitter emitter) {
    emitter(
        state.copyWith(
            asyncSnapshot: AsyncSnapshot.withError(ConnectionState.done, error)
        )
    );
    addError(error);
  }


  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
