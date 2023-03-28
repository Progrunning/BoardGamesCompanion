import 'package:freezed_annotation/freezed_annotation.dart';

export '../../extensions/playthrough_chronology_extensions.dart';

part 'playthrough_chronology.freezed.dart';

@freezed
class PlaythroughTimeline with _$PlaythroughTimeline {
  const factory PlaythroughTimeline.now() = _now;
  const factory PlaythroughTimeline.inThePast() = _inThePast;
}
