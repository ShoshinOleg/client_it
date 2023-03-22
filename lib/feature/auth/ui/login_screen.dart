import 'package:client_it/app/ui/components/app_text_button.dart';
import 'package:client_it/app/ui/components/app_text_field.dart';
import 'package:flutter/material.dart';

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
                      print("OK");
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
}
