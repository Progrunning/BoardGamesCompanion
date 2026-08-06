import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../services/app_icon_service.dart';
import '../../services/purchase_service.dart';

part 'app_icon_picker_view_model.g.dart';

/// Drives the Supporter-only alternate-app-icon picker on the tip screen.
///
/// This is a dedicated, small view model (rather than an addition to
/// [TipViewModel]) so the two Supporter cosmetic perks — badge and
/// icon-picker — can evolve independently. The only gating rule is
/// cosmetic: [availableIconIds] is only ever populated for a Supporter,
/// never affecting any app functionality.
@singleton
class AppIconPickerViewModel = _AppIconPickerViewModel with _$AppIconPickerViewModel;

abstract class _AppIconPickerViewModel with Store {
  _AppIconPickerViewModel(
    this._purchaseService,
    this._appIconService,
  );

  final PurchaseService _purchaseService;
  final AppIconService _appIconService;

  @observable
  ObservableList<String> availableIconIds = ObservableList<String>();

  @observable
  String? currentIconId;

  @observable
  bool isApplyingIcon = false;

  /// Whether the current user is entitled to the icon-picker cosmetic
  /// perk. Purely presentational — never gates app functionality.
  @computed
  bool get isSupporter => _purchaseService.supporterStatus == SupporterStatus.supporter;

  /// Loads the icon choices to offer, gated on [isSupporter]: a
  /// non-Supporter is offered no icons and the platform service is left
  /// untouched, so the perk stays purely cosmetic and additive.
  @action
  Future<void> loadAvailableIcons() async {
    if (!isSupporter) {
      availableIconIds = ObservableList<String>();
      return;
    }

    availableIconIds = ObservableList.of(await _appIconService.getAvailableIconIds());
    currentIconId = await _appIconService.getCurrentIconId();
  }

  /// Applies [iconId] via the platform's native icon-switching mechanism.
  /// A no-op for a non-Supporter, or when [iconId] is already active.
  @action
  Future<void> selectIcon(String iconId) async {
    if (!isSupporter || iconId == currentIconId) {
      return;
    }

    isApplyingIcon = true;
    try {
      await _appIconService.setIcon(iconId);
      currentIconId = iconId;
    } finally {
      isApplyingIcon = false;
    }
  }
}
