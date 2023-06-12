import 'package:injectable/injectable.dart';

@singleton
class EnvironmentService {
  String get searchBoardGamesApiBaseUrl =>
      const String.fromEnvironment('searchBoardGamesApiBaseUrl');
  String get searchBoardGamesApiSubscriptionKey =>
      const String.fromEnvironment('searchBoardGamesApiSubscriptionKey');
}
