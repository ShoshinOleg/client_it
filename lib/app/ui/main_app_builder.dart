import 'package:client_it/app/di/init_di.dart';
import 'package:client_it/app/domain/app_builder.dart';
import 'package:client_it/app/ui/root_screen.dart';
import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:client_it/feature/posts/domain/repositories/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/posts/domain/state/cubit/post_cubit.dart';

class MainAppBuilder implements AppBuilder {
  @override
  Widget buildApp() {
    return const _GlobalProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RootScreen()
      )
    );
  }
}

class _GlobalProviders extends StatelessWidget {

  const _GlobalProviders({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => locator.get<AuthCubit>()
          ),
          BlocProvider(
              create: (context) =>
                PostBloc(
                  locator.get<PostRepository>(),
                  locator.get<AuthCubit>()
                )..add(PostEvent.fetch())
          )
        ],
        child: child
    );
  }
}
