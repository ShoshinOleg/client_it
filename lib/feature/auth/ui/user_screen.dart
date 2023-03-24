import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_state/auth_cubit.dart';
import '../domain/entities/user_entity/user_entity.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Личный кабинет"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
          )
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(userEntity?.username.split("").first ?? "-"),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text(userEntity?.username ?? ""),
                        Text(userEntity?.email ?? ""),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: const Text("Обновить пароль")
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {

                        },
                        child: const Text("Обновить данные")
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
