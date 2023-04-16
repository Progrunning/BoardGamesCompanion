import '../import_result.dart';

class BggPlaysImportRaport {
  int playsToImportTotal = 0;
  int playsFailedToImportTotal = 0;

  int get playsImported => playsToImportTotal - playsFailedToImportTotal;
  double get percentageOfImportedGames => (playsImported / playsToImportTotal) * 100;

  List<ImportError> errors = [];
  List<String> createdPlayers = [];
}
