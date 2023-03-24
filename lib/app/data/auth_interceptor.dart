import 'package:dio/dio.dart';

import '../../feature/auth/domain/auth_state/auth_cubit.dart';
import '../di/init_di.dart';
import 'dio_container.dart';

class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = locator.get<AuthCubit>()
      .state.whenOrNull(
         authorized: (userEntry) => userEntry.accessToken
      );

    if (accessToken != null) {
      final headers = options.headers;
      headers["Authorization"] = "Bearer $accessToken";
      super.onRequest(options.copyWith(headers: headers), handler);
    } else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await locator.get<AuthCubit>().refreshToken();
        final request = await locator
          .get<DioContainer>()
          .dio
          .request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.data,
          );
        return handler.resolve(request);
      } catch(error) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}