import 'package:injectable/injectable.dart';

import 'rate_and_review_service.dart';
import 'support_prompt_service.dart';

/// The single funnel for significant-action counting - every engagement
/// prompt (rate & review, support) counts the same actions, so call sites
/// bump one thing and adding a prompt only touches this class.
@singleton
class EngagementPromptsService {
  EngagementPromptsService(this._rateAndReviewService, this._supportPromptService);

  final RateAndReviewService _rateAndReviewService;
  final SupportPromptService _supportPromptService;

  Future<void> increaseNumberOfSignificantActions() async {
    await _rateAndReviewService.increaseNumberOfSignificantActions();
    await _supportPromptService.increaseNumberOfSignificantActions();
  }
}
