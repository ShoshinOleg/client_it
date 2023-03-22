import 'package:client_it/app/ui/main_app_builder.dart';
import 'package:client_it/app/ui/main_app_runner.dart';

void main() {
  const env = String.fromEnvironment("env", defaultValue: "prod");
  const runner = MainAppRunner(env);
  final builder = MainAppBuilder();
  runner.run(builder);
}
