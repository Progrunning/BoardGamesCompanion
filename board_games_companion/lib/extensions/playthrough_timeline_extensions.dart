import '../common/app_text.dart';
import '../pages/playthroughs/playthrough_timeline.dart';

extension PlaythroughTimelineExtensions on PlaythroughTimeline {
  String toFormattedText() {
    return when(
      now: () => AppText.playthroughsLogTimelineNowName,
      inThePast: () => AppText.playthroughsLogTimelineInThePastName,
    );
  }
}
