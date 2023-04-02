import 'package:board_games_companion/pages/playthroughs/playthrough_migration.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_migration_page_arguments.freezed.dart';

@freezed
class PlaythroughMigrationArguments with _$PlaythroughMigrationArguments {
  const factory PlaythroughMigrationArguments({
    required PlaythroughMigration playthroughMigration,
  }) = _PlaythroughMigrationArguments;

  const PlaythroughMigrationArguments._();
}
