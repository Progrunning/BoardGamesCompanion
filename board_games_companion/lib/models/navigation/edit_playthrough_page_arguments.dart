import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_playthrough_page_arguments.freezed.dart';

@freezed
class EditPlaythroughPageArguments with _$EditPlaythroughPageArguments {
  const factory EditPlaythroughPageArguments({
    required String playthroughId,
    required String boardGameId,
    required String goBackPageRoute,
  }) = _EditPlaythroughPageArguments;
}
