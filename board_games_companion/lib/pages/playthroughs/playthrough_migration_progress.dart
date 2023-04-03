import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_migration_progress.freezed.dart';

@freezed
class PlaythroughMigrationProgress with _$PlaythroughMigrationProgress {
  const factory PlaythroughMigrationProgress.init() = _init;
  const factory PlaythroughMigrationProgress.inProgress() = _inProgress;
  const factory PlaythroughMigrationProgress.success() = _success;
  const factory PlaythroughMigrationProgress.invalid({required String validationErrorMessage}) =
      _invalid;
  const factory PlaythroughMigrationProgress.failure() = _failure;
}
