import 'package:client_it/app/ui/components/app_text_button.dart';
import 'package:client_it/app/ui/components/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_state/auth_cubit.dart';

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userEntity?.username ?? "", textAlign: TextAlign.start,),
                        Text(userEntity?.email ?? "", textAlign: TextAlign.start,),
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
                          showDialog(
                              context: context,
                              builder: (context) => const _UserUpdateDialog()
                          );
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

class _UserUpdateDialog extends StatefulWidget {
  const _UserUpdateDialog({Key? key}) : super(key: key);

  @override
  State<_UserUpdateDialog> createState() => _UserUpdateDialogState();
}

class _UserUpdateDialogState extends State<_UserUpdateDialog> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      children: [
        AppTextField(controller: usernameController, labelText: "username"),
        const SizedBox(height: 16),
        AppTextField(controller: emailController, labelText: "email"),
        const SizedBox(height: 16),
        AppTextButton(
            onPressed: () {
              context.read<AuthCubit>().userUpdate(
                email: emailController.text,
                username: usernameController.text
              );
            },
            text: "Применить"
        )
      ],
    );
  }
}

