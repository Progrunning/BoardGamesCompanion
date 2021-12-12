import 'package:flutter/material.dart';

import '../common/analytics.dart';
import '../injectable.dart';
import '../pages/edit_playthrough/edit_playthrough_page.dart';
import '../pages/edit_playthrough/edit_playthrouhg_view_model.dart';
import '../services/analytics_service.dart';
import '../stores/playthrough_store.dart';
import '../stores/playthroughs_store.dart';
import 'navigator_transitions.dart';

// ignore: avoid_classes_with_only_static_members
class NavigatorHelper {
  
  
  static Future<T?> navigateToEditPlaythrough<T extends Object>(
    BuildContext context,
    PlaythroughStore playthroughStore,
  ) async {
    final analytics = getIt<AnalyticsService>();
    final PlaythroughsStore playthroughsStore = getIt<PlaythroughsStore>();

    analytics.logEvent(
      name: Analytics.EditPlaythrough,
      parameters: <String, String>{
        Analytics.BoardGameIdParameter: playthroughStore.playthrough.boardGameId,
      },
    );

    return Navigator.push(
      context,
      NavigatorTransitions.fadeScale(
        (_, __, ___) {
          return EditPlaythoughPage(
            viewModel: EditPlaythoughViewModel(playthroughStore, playthroughsStore),
          );
        },
      ),
    );
  }
}
