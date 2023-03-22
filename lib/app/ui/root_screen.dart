import 'package:client_it/app/ui/app_loader.dart';
import 'package:client_it/feature/auth/ui/components/auth_builder.dart';
import 'package:client_it/feature/main/ui/main_screen.dart';
import 'package:flutter/widgets.dart';

import '../../feature/auth/ui/login_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthBuilder(
      isNotAuthorized: (context) => const LoginScreen(),
      isWaiting: (context) => const AppLoader(),
      isAuthorized: (context, userEntity, child) =>
        MainScreen(userEntity: userEntity)
    );
  }
}
