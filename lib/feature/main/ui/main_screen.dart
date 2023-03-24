import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/domain/entities/user_entity/user_entity.dart';

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
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AuthCubit>().getProfile(),
          ),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthCubit>().logout(),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("username: ${userEntity.username}"),
          const SizedBox(height: 20),
          Text("accessToken: ${userEntity.accessToken}"),
          const SizedBox(height: 20),
          Text("refreshToken: ${userEntity.refreshToken}"),
          const SizedBox(height: 20),
        ],
      )
    );
  }
}
