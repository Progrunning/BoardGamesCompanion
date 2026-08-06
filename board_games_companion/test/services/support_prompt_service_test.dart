import 'package:board_games_companion/services/engagement_prompt_session_guard.dart';
import 'package:board_games_companion/services/support_prompt_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/preference_service_mock.dart';
import '../mocks/rate_and_review_service_mock.dart';

void main() {
  late MockPreferencesService mockPreferencesService;
  late MockRateAndReviewService mockRateAndReviewService;
  late SupportPromptService supportPromptService;

  final DateTime nowUtc = DateTime.now().toUtc();

  void stubPreferences({
    bool rateAndReviewDialogSeen = true,
    DateTime? rateAndReviewResolvedAt,
    bool supportPromptNeverAskAgain = false,
    DateTime? firstTimeLaunchDate,
    DateTime? supportPromptRemindMeLaterDate,
    int numberOfSignificantActions = 0,
    bool rateAndReviewShowDialog = false,
  }) {
    when(() => mockPreferencesService.getRateAndReviewDialogSeen())
        .thenReturn(rateAndReviewDialogSeen);
    when(() => mockPreferencesService.getRateAndReviewResolvedAt())
        .thenReturn(rateAndReviewResolvedAt);
    when(() => mockPreferencesService.setRateAndReviewResolvedAt(any()))
        .thenAnswer((_) async {});
    when(() => mockPreferencesService.getSupportPromptNeverAskAgain())
        .thenReturn(supportPromptNeverAskAgain);
    when(() => mockPreferencesService.setSupportPromptNeverAskAgain())
        .thenAnswer((_) async {});
    when(() => mockPreferencesService.getFirstTimeLaunchDate()).thenReturn(
      firstTimeLaunchDate ?? nowUtc.subtract(const Duration(days: 100)),
    );
    when(() => mockPreferencesService.getSupportPromptRemindMeLaterDate())
        .thenReturn(supportPromptRemindMeLaterDate);
    when(() => mockPreferencesService.setSupportPromptRemindMeLaterDate(any()))
        .thenAnswer((_) async {});
    when(() => mockPreferencesService.getNumberOfSignificantActionsForSupportPrompt())
        .thenReturn(numberOfSignificantActions);
    when(() => mockPreferencesService.setNumberOfSignificantActionsForSupportPrompt(any()))
        .thenAnswer((_) async {});
    when(() => mockPreferencesService.setSupportPromptSeen()).thenAnswer((_) async {});
    when(() => mockRateAndReviewService.showRateAndReviewDialog)
        .thenReturn(rateAndReviewShowDialog);
  }

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    mockRateAndReviewService = MockRateAndReviewService();
    supportPromptService = SupportPromptService(
      mockPreferencesService,
      mockRateAndReviewService,
    );

    EngagementPromptSessionGuard.reset();

    // MK Sensible "everything satisfied" baseline - individual tests override
    // just the bit under test.
    stubPreferences(
      rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
      numberOfSignificantActions: 150,
    );
  });

  tearDown(() {
    EngagementPromptSessionGuard.reset();
  });

  group('GIVEN all eligibility conditions are satisfied', () {
    test('WHEN a significant action is recorded THEN the support prompt becomes eligible',
        () async {
      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isTrue);
    });
  });

  group('GIVEN the number of significant actions is below the required threshold', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        numberOfSignificantActions: 1,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });

    test('WHEN a significant action is recorded THEN the counter is incremented', () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        numberOfSignificantActions: 1,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      verify(() => mockPreferencesService.setNumberOfSignificantActionsForSupportPrompt(2))
          .called(1);
    });
  });

  group('GIVEN the number of significant actions already reached the required threshold', () {
    test('WHEN a significant action is recorded THEN the counter is not incremented further',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      verifyNever(() => mockPreferencesService.setNumberOfSignificantActionsForSupportPrompt(
            any(),
          ));
    });
  });

  group('GIVEN the rate-and-review prompt has not been resolved yet', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      stubPreferences(
        rateAndReviewDialogSeen: false,
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the rate-and-review prompt was resolved less than the cooldown ago', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 1)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the rate-and-review prompt was resolved more than the cooldown ago', () {
    test('WHEN a significant action is recorded THEN the support prompt is eligible', () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 4)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isTrue);
    });
  });

  group('GIVEN the rate-and-review resolution date has never been observed before', () {
    test('WHEN a significant action is recorded THEN it is stamped as resolved now, '
        'and the support prompt is not yet eligible (cooldown has not elapsed)', () async {
      stubPreferences(
        rateAndReviewResolvedAt: null,
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      verify(() => mockPreferencesService.setRateAndReviewResolvedAt(any())).called(1);
      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the rate-and-review prompt currently wants to be shown this session', () {
    test('WHEN a significant action is recorded THEN the support prompt defers to it', () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        numberOfSignificantActions: 150,
        rateAndReviewShowDialog: true,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the app was first launched less than the required duration ago', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        firstTimeLaunchDate: nowUtc.subtract(const Duration(days: 1)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the user asked to be reminded later, and that period has not elapsed', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        supportPromptRemindMeLaterDate: nowUtc.add(const Duration(days: 5)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('GIVEN the user asked to be reminded later, and that period has elapsed', () {
    test('WHEN a significant action is recorded THEN the support prompt is eligible', () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        supportPromptRemindMeLaterDate: nowUtc.subtract(const Duration(days: 1)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isTrue);
    });
  });

  group('WHEN askMeLater is called', () {
    test('THEN the reminder date is pushed out by the remind-me-later duration and the dialog '
        'flag is cleared', () async {
      supportPromptService.showSupportPromptDialog = true;

      await supportPromptService.askMeLater();

      expect(supportPromptService.showSupportPromptDialog, isFalse);

      final DateTime capturedDate = verify(
        () => mockPreferencesService.setSupportPromptRemindMeLaterDate(captureAny()),
      ).captured.single as DateTime;

      final Duration difference = capturedDate.difference(DateTime.now().toUtc());
      expect(difference.inDays, closeTo(10, 1));
    });
  });

  group('GIVEN the user chose never ask again', () {
    test('WHEN dontAskAgain is called THEN the never-ask-again flag is persisted permanently',
        () async {
      supportPromptService.showSupportPromptDialog = true;

      await supportPromptService.dontAskAgain();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
      verify(() => mockPreferencesService.setSupportPromptNeverAskAgain()).called(1);
    });

    test('WHEN more significant actions accumulate THEN the support prompt stays ineligible',
        () async {
      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        supportPromptNeverAskAgain: true,
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });

  group('WHEN the user taps Tip on the prompt', () {
    test('THEN the prompt is resolved permanently and the dialog flag is cleared', () async {
      supportPromptService.showSupportPromptDialog = true;

      await supportPromptService.tip();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
      verify(() => mockPreferencesService.setSupportPromptNeverAskAgain()).called(1);
    });
  });

  group('WHEN promptShown is called', () {
    test('THEN it is marked seen and the session guard is claimed', () async {
      await supportPromptService.promptShown();

      verify(() => mockPreferencesService.setSupportPromptSeen()).called(1);
      expect(EngagementPromptSessionGuard.promptShownThisSession, isTrue);
    });
  });

  group('GIVEN an engagement prompt was already shown earlier this session', () {
    test('WHEN a significant action is recorded THEN the support prompt is not eligible',
        () async {
      EngagementPromptSessionGuard.promptShownThisSession = true;

      stubPreferences(
        rateAndReviewResolvedAt: nowUtc.subtract(const Duration(days: 30)),
        numberOfSignificantActions: 150,
      );

      await supportPromptService.increaseNumberOfSignificantActions();

      expect(supportPromptService.showSupportPromptDialog, isFalse);
    });
  });
}
