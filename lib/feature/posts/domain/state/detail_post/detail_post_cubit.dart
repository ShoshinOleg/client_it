import 'package:bloc/bloc.dart';
import 'package:client_it/feature/posts/domain/entity/post/post_entity.dart';
import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_post_state.dart';
part 'detail_post_cubit.freezed.dart';

class DetailPostCubit extends Cubit<DetailPostState> {
  DetailPostCubit(
    this.postRepository,
    this.id
  ) : super(const DetailPostState());

  final PostRepository postRepository;
  final String id;

  Future<void> fetchPost() async {
    emit(state.copyWith(asyncSnapshot: const AsyncSnapshot.waiting()));
    Future.delayed(const Duration(seconds: 1));
    await postRepository.fetchPost(id).then((value) {
      emit(state.copyWith(
        postEntity: value,
        asyncSnapshot: const AsyncSnapshot.withData(
            ConnectionState.done,
            "Успешное получение поста"
        )
      ));
    }).catchError((erorr) {
      addError(erorr);
    });
  }

  Future<void> deletePost() async {
    emit(state.copyWith(asyncSnapshot: const AsyncSnapshot.waiting()));
    Future.delayed(const Duration(seconds: 1));
    await postRepository.deletePost(id).then((value) {
      emit(state.copyWith(
          asyncSnapshot: const AsyncSnapshot.withData(
              ConnectionState.done,
              "Успешное удаление поста"
          )
      ));
    }).catchError((erorr) {
      addError(erorr);
    });
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
}
