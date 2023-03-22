import 'package:client_it/app/ui/components/app_text_button.dart';
import 'package:client_it/app/ui/components/app_text_field.dart';
import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({Key? key}) : super(key: key);

  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LoginScreen")),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: controllerLogin,
                  labelText: "логин",
                ),
                const SizedBox(height: 16),
                AppTextField(
                  obscureText: true,
                  controller: controllerPassword,
                  labelText: "пароль",
                ),
                const SizedBox(height: 16,),
                AppTextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      _onTapToSignIn(context.read<AuthCubit>());
                    }
                  },
                  text: "Войти",
                ),
                const SizedBox(height: 16,),
                AppTextButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {

                  },
                  text: "Регистрация",
                )
              ]
            ),
          ),
        ),
      )
    );
  }

  void _onTapToSignIn(AuthCubit authCubit) => authCubit.signIn(
      username: controllerLogin.text,
      password: controllerPassword.text
  );
}
