abstract class AppApi {
  Future<dynamic> signUp({
    required String username,
    required String email,
    required String password
  });

  Future<dynamic> signIn({
    required String username,
    required String password
  });

  Future<dynamic> getProfile();

  Future<dynamic> userUpdate({
    String? username,
    String? email
  });

  Future<dynamic> passwordUpdate({
    required String oldPassword,
    required String newPassword,
  });

  Future<dynamic> refreshToken({
    String? refreshToken
  });

  Future<dynamic> request(
      String path,
      {
        required data,
        required queryParameters
      }
  );
}