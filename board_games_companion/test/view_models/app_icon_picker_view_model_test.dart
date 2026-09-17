import 'package:board_games_companion/pages/tip/app_icon_picker_view_model.dart';
import 'package:board_games_companion/services/app_icon_service.dart';
import 'package:board_games_companion/services/purchase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/app_icon_service_mock.dart';
import '../mocks/purchase_service_mock.dart';

void main() {
  late MockPurchaseService mockPurchaseService;
  late MockAppIconService mockAppIconService;
  late AppIconPickerViewModel appIconPickerViewModel;

  setUp(() {
    mockPurchaseService = MockPurchaseService();
    mockAppIconService = MockAppIconService();

    appIconPickerViewModel = AppIconPickerViewModel(mockPurchaseService, mockAppIconService);
  });

  group('GIVEN the current user is not a Supporter ', () {
    setUp(() {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.notSupporter);
    });

    test(
        'WHEN the icon picker loads its available icons '
        'THEN no icons are offered and the platform service is left untouched ', () async {
      await appIconPickerViewModel.loadAvailableIcons();

      expect(appIconPickerViewModel.availableIconIds, isEmpty);
      verifyNever(() => mockAppIconService.getAvailableIconIds());
      verifyNever(() => mockAppIconService.getCurrentIconId());
    });

    test(
        'WHEN selectIcon is called '
        'THEN the picker does not apply the icon change ', () async {
      await appIconPickerViewModel.selectIcon(AppIconIds.supporter);

      verifyNever(() => mockAppIconService.setIcon(any()));
      expect(appIconPickerViewModel.currentIconId, isNull);
    });
  });

  group('GIVEN the current user is a Supporter ', () {
    setUp(() {
      when(() => mockPurchaseService.supporterStatus).thenReturn(SupporterStatus.supporter);
    });

    test(
        'WHEN the icon picker loads its available icons '
        'THEN the Supporter is offered every icon the platform reports ', () async {
      when(() => mockAppIconService.getAvailableIconIds())
          .thenAnswer((_) async => <String>[AppIconIds.defaultIcon, AppIconIds.supporter]);
      when(() => mockAppIconService.getCurrentIconId())
          .thenAnswer((_) async => AppIconIds.defaultIcon);

      await appIconPickerViewModel.loadAvailableIcons();

      expect(appIconPickerViewModel.availableIconIds,
          <String>[AppIconIds.defaultIcon, AppIconIds.supporter]);
      expect(appIconPickerViewModel.currentIconId, AppIconIds.defaultIcon);
    });

    test(
        'WHEN selecting a different icon '
        'THEN the platform service applies it and the picker reflects the new selection ',
        () async {
      when(() => mockAppIconService.getAvailableIconIds())
          .thenAnswer((_) async => <String>[AppIconIds.defaultIcon, AppIconIds.supporter]);
      when(() => mockAppIconService.getCurrentIconId())
          .thenAnswer((_) async => AppIconIds.defaultIcon);
      when(() => mockAppIconService.setIcon(AppIconIds.supporter)).thenAnswer((_) async {});
      await appIconPickerViewModel.loadAvailableIcons();

      await appIconPickerViewModel.selectIcon(AppIconIds.supporter);

      verify(() => mockAppIconService.setIcon(AppIconIds.supporter)).called(1);
      expect(appIconPickerViewModel.currentIconId, AppIconIds.supporter);
      expect(appIconPickerViewModel.isApplyingIcon, isFalse);
    });

    test(
        'WHEN selecting the icon that is already active '
        'THEN the platform service is not called again ', () async {
      when(() => mockAppIconService.getAvailableIconIds())
          .thenAnswer((_) async => <String>[AppIconIds.defaultIcon]);
      when(() => mockAppIconService.getCurrentIconId())
          .thenAnswer((_) async => AppIconIds.defaultIcon);
      await appIconPickerViewModel.loadAvailableIcons();

      await appIconPickerViewModel.selectIcon(AppIconIds.defaultIcon);

      verifyNever(() => mockAppIconService.setIcon(any()));
    });
  });
}
