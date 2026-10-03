import 'package:board_games_companion/services/rate_and_review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/preference_service_mock.dart';

void main() {
  late MockPreferencesService mockPreferencesService;
  late RateAndReviewService rateAndReviewService;

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    rateAndReviewService = RateAndReviewService(mockPreferencesService);

    when(() => mockPreferencesService.setRateAndReviewDialogSeen()).thenAnswer((_) async {});
    when(() => mockPreferencesService.setRateAndReviewResolvedAt(any()))
        .thenAnswer((_) async {});
  });

  group('GIVEN the user dismisses the rate-and-review prompt forever', () {
    test('WHEN dontAskAgain is called THEN the prompt is marked seen and the resolution '
        'moment is stamped (it starts the support prompt cooldown)', () async {
      rateAndReviewService.showRateAndReviewDialog = true;

      await rateAndReviewService.dontAskAgain();

      expect(rateAndReviewService.showRateAndReviewDialog, isFalse);
      verify(() => mockPreferencesService.setRateAndReviewDialogSeen()).called(1);

      final DateTime capturedDate = verify(
        () => mockPreferencesService.setRateAndReviewResolvedAt(captureAny()),
      ).captured.single as DateTime;
      expect(
        DateTime.now().toUtc().difference(capturedDate).inMinutes,
        closeTo(0, 1),
      );
    });
  });
}
