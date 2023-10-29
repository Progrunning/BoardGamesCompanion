import '../import_result.dart';
import 'bgg_play.dart';

class BggPlaysImportResult extends ImportResult<List<BggPlay>> {
  BggPlaysImportResult();

  BggPlaysImportResult.failure(List<ImportError> super.errors) : super.failure();

  bool get isPartialSuccess => playsFailedToImportTotal != playsToImportTotal;

  int playsToImportTotal = 0;
  int get playsFailedToImportTotal => playsToImportTotal - (data?.length ?? 0);
}
