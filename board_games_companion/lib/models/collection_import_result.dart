import 'hive/board_game_details.dart';
import 'import_result.dart';

class CollectionImportResult extends ImportResult<List<BoardGameDetails>> {
  CollectionImportResult();

  CollectionImportResult.failure(List<ImportError> super.errors) : super.failure();
}
