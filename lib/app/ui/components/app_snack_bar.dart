import 'package:flutter/material.dart';

import '../../domain/error_entity/error_entity.dart';

abstract class AppSnackBar {
  static void showSnackBarWithError(BuildContext buildContext, ErrorEntity error) {
    ScaffoldMessenger.maybeOf(buildContext)?.showSnackBar(
        SnackBar(
            duration: const Duration(seconds: 5),
            content: SingleChildScrollView(
              child: Text(
                  maxLines: 5,
                  "Error: ${error.errorMessage}, Message: ${error.message}"
              ),
            )
        )
    );
  }

  static void showSnackBarWithMessage(BuildContext buildContext, String message) {
    ScaffoldMessenger.maybeOf(buildContext)?.showSnackBar(
        SnackBar(
            duration: const Duration(seconds: 5),
            content: SingleChildScrollView(
              child: Text(maxLines: 5, message),
            )
        )
    );
  }

  static void clearSnackBars(BuildContext buildContext, String message) {
    ScaffoldMessenger.maybeOf(buildContext)?.clearSnackBars();
  }
}