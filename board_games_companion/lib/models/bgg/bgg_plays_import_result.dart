import 'package:board_games_companion/models/import_result.dart';

import 'bgg_play.dart';

class BggPlaysImportResult extends ImportResult<List<BggPlay>> {
  BggPlaysImportResult();

  BggPlaysImportResult.failure(List<ImportError> errors) : super.failure(errors);

  bool get isPartialSuccess => playsFailedToImportTotal != playsToImportTotal;

  int playsToImportTotal = 0;
  int get playsFailedToImportTotal => playsToImportTotal - (data?.length ?? 0);
}
