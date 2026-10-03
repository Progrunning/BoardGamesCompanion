import 'package:board_games_companion/services/engagement_prompts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/rate_and_review_service_mock.dart';
import '../mocks/support_prompt_service_mock.dart';

void main() {
  late MockRateAndReviewService mockRateAndReviewService;
  late MockSupportPromptService mockSupportPromptService;
  late EngagementPromptsService engagementPromptsService;

  setUp(() {
    mockRateAndReviewService = MockRateAndReviewService();
    mockSupportPromptService = MockSupportPromptService();
    engagementPromptsService = EngagementPromptsService(
      mockRateAndReviewService,
      mockSupportPromptService,
    );

    when(() => mockRateAndReviewService.increaseNumberOfSignificantActions())
        .thenAnswer((_) async {});
    when(() => mockSupportPromptService.increaseNumberOfSignificantActions())
        .thenAnswer((_) async {});
  });

  group('GIVEN a user performs a significant action', () {
    test('WHEN it is recorded THEN every engagement prompt counts it', () async {
      await engagementPromptsService.increaseNumberOfSignificantActions();

      verify(() => mockRateAndReviewService.increaseNumberOfSignificantActions()).called(1);
      verify(() => mockSupportPromptService.increaseNumberOfSignificantActions()).called(1);
    });
  });
}
