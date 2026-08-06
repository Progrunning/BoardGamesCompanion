class EnvironmentService {
  String get searchBoardGamesApiBaseUrl =>
      const String.fromEnvironment('searchBoardGamesApiBaseUrl');
  String get searchBoardGamesApiSubscriptionKey =>
      const String.fromEnvironment('searchBoardGamesApiSubscriptionKey');
  String get bggApiKey => const String.fromEnvironment('bggApiKey');
  String get revenueCatApiKeyIos => const String.fromEnvironment('revenueCatApiKeyIos');
  String get revenueCatApiKeyAndroid =>
      const String.fromEnvironment('revenueCatApiKeyAndroid');
}
