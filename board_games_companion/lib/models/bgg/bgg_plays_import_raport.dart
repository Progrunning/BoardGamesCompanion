import 'package:board_games_companion/models/import_result.dart';

class BggPlaysImportRaport {
  int playsToImportTotal = 0;
  int playsFailedToImportTotal = 0;

  List<ImportError> errors = [];
  List<String> createdPlayers = [];
}
