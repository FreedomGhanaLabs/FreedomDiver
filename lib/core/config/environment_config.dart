// ignore_for_file: sort_constructors_first

enum Environment { development, staging, production }

class EnvironmentConfig {
  EnvironmentConfig({
    required this.baseUrl,
    required this.appName,
    this.enableLogging = false,
  });
  final String baseUrl;
  final String appName;
  final bool enableLogging;

  static late EnvironmentConfig _instance;
  static void setEnvironment(Environment environment) {
    switch (environment) {
      case Environment.development:
        EnvironmentConfig._instance = EnvironmentConfig(
          baseUrl: 'https://freedomgh.com',
          appName: 'Freedom Driver',
          enableLogging: true,
        );
      case Environment.staging:
        EnvironmentConfig._instance = EnvironmentConfig(
          baseUrl: 'https://freedomgh.com',
          appName: '[STG] Freedom Driver',
          enableLogging: true,
        );
      case Environment.production:
        EnvironmentConfig._instance = EnvironmentConfig(
          baseUrl: 'https://freedomgh.com',
          appName: '[DEV] Freedom Driver',
          enableLogging: true,
        );
    }
  }

  static EnvironmentConfig get instance {
    return _instance;
  }
}
