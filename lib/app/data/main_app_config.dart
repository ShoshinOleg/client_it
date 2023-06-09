import 'package:injectable/injectable.dart';

import '../domain/app_config.dart';

@Singleton(as: AppConfig)
@prod
class ProdAppConfig implements AppConfig {
  @override
  String get baseUrl => "http://192.168.1.66:80";

  @override
  String get host => Environment.prod;
}

@Singleton(as: AppConfig)
@dev
class DevAppConfig implements AppConfig {
  @override
  String get baseUrl => "http://192.168.1.66:80";

  @override
  String get host => Environment.dev;
}

@Singleton(as: AppConfig)
@test
class TestAppConfig implements AppConfig {
  @override
  String get baseUrl => "http://192.168.1.66:80";

  @override
  String get host => Environment.test;
}