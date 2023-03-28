import '../common/app_text.dart';
import '../pages/playthroughs/playthrough_chronology.dart';

extension PlaythroughChronologyExtensions on PlaythroughTimeline {
  String toFormattedText() {
    return when(
      now: () => AppText.playthroughsLogTimelineNowName,
      inThePast: () => AppText.playthroughsLogTimelineInThePastName,
    );
  }
}
