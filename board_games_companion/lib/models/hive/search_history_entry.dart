import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'search_history_entry.freezed.dart';
part 'search_history_entry.g.dart';

@freezed
class SearchHistoryEntry with _$SearchHistoryEntry {
  @HiveType(typeId: HiveBoxes.searchHistoryEntryId, adapterName: 'SearchHistoryEntryAdapter')
  const factory SearchHistoryEntry({
    @HiveField(0) required String query,
    @HiveField(1) required DateTime dateTime,
  }) = _SearchHistoryEntry;
}
