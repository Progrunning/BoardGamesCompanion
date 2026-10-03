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
    when(() => mockPreferencesService.getAppLaunchDate()).thenReturn(appLaunchDate ?? daysAgo(1));
    when(() => mockPreferencesService.getLastReviewRequestDate()).thenReturn(lastReviewRequestDate);
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

  group('GIVEN requestReview is called', () {
    test(
        'WHEN in-app review is available '
        'THEN it silently triggers the native in-app review', () async {
      await rateAndReviewService.requestReview();

      verify(() => mockInAppReview.requestReview()).called(1);
    });

    test(
        'WHEN in-app review is available '
        'THEN it records the attempt timestamp so future attempts can be rate limited', () async {
      await rateAndReviewService.requestReview();

      verify(() => mockPreferencesService.setLastReviewRequestDate(any())).called(1);
    });

    test(
        'WHEN in-app review is unavailable '
        'THEN it does nothing and records no attempt', () async {
      when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => false);

      await rateAndReviewService.requestReview();

      verifyNever(() => mockInAppReview.requestReview());
      verifyNever(() => mockPreferencesService.setLastReviewRequestDate(any()));
    });

    test(
        'WHEN it completes '
        'THEN it clears the should request review flag', () async {
      rateAndReviewService.shouldRequestReview = true;

      await rateAndReviewService.requestReview();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });
  });

  group('GIVEN shouldRequestReview eligibility is evaluated', () {
    test(
        'WHEN all criteria are met and no attempt was ever made '
        'THEN it is true', () async {
      stubEligible(lastReviewRequestDate: null);

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isTrue);
    });

    test(
        'WHEN the app has not been used long enough '
        'THEN it is false', () async {
      stubEligible(firstTimeLaunchDate: daysAgo(2));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test(
        'WHEN there are not enough significant actions '
        'THEN it is false', () async {
      stubEligible(numberOfSignificantActions: 100);

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test(
        'WHEN an attempt was made recently (3 per year cap) '
        'THEN it is false', () async {
      stubEligible(lastReviewRequestDate: daysAgo(10));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isFalse);
    });

    test(
        'WHEN enough time has passed since the last attempt '
        'THEN it is true again', () async {
      stubEligible(lastReviewRequestDate: daysAgo(130));

      await rateAndReviewService.increaseNumberOfSignificantActions();

      expect(rateAndReviewService.shouldRequestReview, isTrue);
    });
  });
}
