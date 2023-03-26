import 'package:client_it/app/di/init_di.dart';
import 'package:client_it/app/domain/error_entity/error_entity.dart';
import 'package:client_it/app/ui/app_loader.dart';
import 'package:client_it/app/ui/components/app_snack_bar.dart';
import 'package:client_it/feature/posts/domain/entity/post/post_entity.dart';
import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:client_it/feature/posts/domain/state/detail_post/detail_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPostScreen extends StatelessWidget {
  const DetailPostScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DetailPostCubit(locator.get<PostRepository>(), id)..fetchPost(),
      child: const _DetailPostView(),
    );
  }
}

class _DetailPostView extends StatelessWidget {
  const _DetailPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<DetailPostCubit>().deletePost().then((_) {
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.delete)
          )
        ],
      ),
      body: BlocConsumer<DetailPostCubit, DetailPostState>(
        builder: (context, state) {
          if (state.asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (state.postEntity != null) {
            return _DetailPostItem(postEntity: state.postEntity!);
          }
          return const Center(
            child: Text("Что-то пошло не так"),
          );
        },
        listener: (context, state) {
          if (state.asyncSnapshot.hasData) {
            AppSnackBar.showSnackBarWithMessage(
              context,
              state.asyncSnapshot.data.toString()
            );
          }
          if (state.asyncSnapshot.hasError) {
            AppSnackBar.showSnackBarWithError(
              context,
              ErrorEntity.fromException(state.asyncSnapshot.error)
            );
            Navigator.of(context).pop();
          }
        }
      ),
    );
  }
}

class _DetailPostItem extends StatelessWidget {
  const _DetailPostItem({
    Key? key,
    required this.postEntity
  }) : super(key: key);

  final PostEntity postEntity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Name: ${postEntity.name}"),
        Text("Name: ${postEntity.content}"),
      ],
    );
  }
}


