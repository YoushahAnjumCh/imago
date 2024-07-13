enum Environment { dev, prod }

abstract class AppEnvironment {
  static late String apiBaseUrl;
  static late String title;
  static late Environment _environment;
  static Environment get environment => _environment;

  static setupEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.dev:
        {
          apiBaseUrl = "http://localhost:8080";
          title = "Dev";
          break;
        }
      case Environment.prod:
        {
          apiBaseUrl = "http://localhost:8080";
          title = "Prod";
        }
    }
  }
}
