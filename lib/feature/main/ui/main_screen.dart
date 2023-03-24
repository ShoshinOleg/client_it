import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:client_it/feature/auth/ui/user_screen.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      )
    );
  }
}
