import 'package:client_it/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBuilder extends StatelessWidget {
  const AuthBuilder({
    Key? key,
    required this.isNotAuthorized,
    required this.isWaiting,
    required this.isAuthorized
  }) : super(key: key);

  final WidgetBuilder isNotAuthorized;
  final WidgetBuilder isWaiting;
  final ValueWidgetBuilder isAuthorized;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return state.when(
            notAuthorized: () => isNotAuthorized(context),
            authorized: (userEntity) => isAuthorized(context, userEntity, null),
            waiting: () => isWaiting(context),
            error: (error) => isNotAuthorized(context)
        );
      },
      listenWhen: ((previous, current) =>
        previous.mapOrNull(error: (value) => value)
            != current.mapOrNull(error: (value) => value)
      ),
      listener: (context, state) {
        state.whenOrNull(
          error: (error) => _showSnackBar(context, error)
        );
      },
    );
  }

  void _showSnackBar(BuildContext buildContext, dynamic error) {
    ScaffoldMessenger.of(buildContext).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: SingleChildScrollView(
          child: Text(
            maxLines: 5,
            error.toString()
          ),
        )
      )
    );
  }
}
