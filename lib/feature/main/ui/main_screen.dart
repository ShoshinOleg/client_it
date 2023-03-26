import 'package:client_it/app/ui/components/app_dialog.dart';
import 'package:client_it/feature/auth/ui/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/domain/entities/user_entity/user_entity.dart';
import '../../posts/domain/state/cubit/post_cubit.dart';
import '../../posts/ui/components/post/post_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.userEntity}) : super(key: key);

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MainScreen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AppDialog(
                      val1: "name",
                      val2: "content",
                      onPressed: (name, content) {
                        context.read<PostCubit>().createPost(
                          {
                            "name": name,
                            "content": content
                          }
                        );
                      }
                  )
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_box),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserScreen())
              );
              // context.read<AuthCubit>().getProfile();
            },
          ),
        ],
      ),
      body: const PostList()
    );
  }
}
