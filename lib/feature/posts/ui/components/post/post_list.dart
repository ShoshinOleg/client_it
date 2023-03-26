import 'package:client_it/app/ui/app_loader.dart';
import 'package:client_it/feature/posts/ui/components/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/state/cubit/post_cubit.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.postList.isNotEmpty) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.maxScrollExtent ==
                  notification.metrics.pixels) {
                context.read<PostBloc>().add(PostEvent.fetch());
                print(notification);
                return true;
              }
              return false;
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.postList.length,
              itemBuilder: (context, index) {
                return PostItem(postEntity: state.postList[index]);
              }
            ),
          );
        }
        if (state.asyncSnapshot?.connectionState == ConnectionState.waiting) {
          return const AppLoader();
        }
        return const SizedBox.shrink();
      },
    );
  }
}