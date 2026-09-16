import 'package:board_games_companion/services/rate_and_review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/in_app_review_mock.dart';
import '../mocks/preference_service_mock.dart';

void main() {
  late MockPreferencesService mockPreferencesService;
  late MockInAppReview mockInAppReview;
  late RateAndReviewService rateAndReviewService;

  DateTime daysAgo(int days) => DateTime.now().toUtc().subtract(Duration(days: days));

  void stubEligible({
    DateTime? firstTimeLaunchDate,
    DateTime? appLaunchDate,
    DateTime? lastReviewRequestDate,
    int numberOfSignificantActions = 300,
  }) {
    when(() => mockPreferencesService.getFirstTimeLaunchDate())
        .thenReturn(firstTimeLaunchDate ?? daysAgo(30));
    when(() => mockPreferencesService.getAppLaunchDate())
        .thenReturn(appLaunchDate ?? daysAgo(1));
    when(() => mockPreferencesService.getLastReviewRequestDate())
        .thenReturn(lastReviewRequestDate);
    when(() => mockPreferencesService.getNumberOfSignificantActions())
        .thenReturn(numberOfSignificantActions);
    when(() => mockPreferencesService.setNumberOfSignificantActions(any()))
        .thenAnswer((_) => Future.value());
  }

  setUpAll(() {
    registerFallbackValue(DateTime.now().toUtc());
  });

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    mockInAppReview = MockInAppReview();
    when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => true);
    when(() => mockInAppReview.requestReview()).thenAnswer((_) => Future.value());
    when(() => mockPreferencesService.setLastReviewRequestDate(any()))
        .thenAnswer((_) => Future.value());
    rateAndReviewService = RateAndReviewService(mockPreferencesService, mockInAppReview);
  });

  group('requestReview', () {
    test('silently triggers the native in-app review when available', () async {
      await rateAndReviewService.requestReview();

      verify(() => mockInAppReview.requestReview()).called(1);
    });

    test('records the attempt timestamp so future attempts can be rate limited', () async {
      await rateAndReviewService.requestReview();

      verify(() => mockPreferencesService.setLastReviewRequestDate(any())).called(1);
    });

    test('does nothing and records no attempt when in-app review is unavailable', () async {
      when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => false);

      await rateAndReviewService.requestReview();

      verifyNever(() => mockInAppReview.requestReview());
      verifyNever(() => mockPreferencesService.setLastReviewRequestDate(any()));
    });

    test('clears the should request review flag', () async {
      rateAndReviewService.shouldRequestReview = true;

      await rateAndReviewService.requestReview();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });
  });

  group('shouldRequestReview eligibility', () {
    test('is true once all criteria are met and no attempt was ever made', () async {
      stubEligible(lastReviewRequestDate: null);

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isTrue);
    });

    test('is false when the app has not been used long enough', () async {
      stubEligible(firstTimeLaunchDate: daysAgo(2));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test('is false when there are not enough significant actions', () async {
      stubEligible(numberOfSignificantActions: 100);

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test('is false when an attempt was made recently (3 per year cap)', () async {
      stubEligible(lastReviewRequestDate: daysAgo(10));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test('is true again once enough time has passed since the last attempt', () async {
      stubEligible(lastReviewRequestDate: daysAgo(130));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isTrue);
    });
  });
}
