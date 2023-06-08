import 'package:injectable/injectable.dart';

@singleton
class EnvironmentService {
  String get searchBoardGamesApiBaseUrl =>
      const String.fromEnvironment('searchBoardGamesApiBaseUrl');
  String get searchBoardGamesApiKey => const String.fromEnvironment('searchBoardGamesApiKey');
}
