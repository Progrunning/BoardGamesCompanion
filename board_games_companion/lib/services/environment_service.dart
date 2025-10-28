class EnvironmentService {
  String get searchBoardGamesApiBaseUrl =>
      const String.fromEnvironment('searchBoardGamesApiBaseUrl');
  String get searchBoardGamesApiSubscriptionKey =>
      const String.fromEnvironment('searchBoardGamesApiSubscriptionKey');
  String get boardGamesGeekBearerToken => const String.fromEnvironment('boardGamesGeekBearerToken');
}
