import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../services/app_icon_service.dart';
import 'app_icon_picker_view_model.dart';

/// Lets a Supporter choose between the default app icon and any alternate
/// icons registered for the current platform.
///
/// Purely cosmetic — never gates app functionality. [TipPage] only renders
/// this section when the current user is a Supporter; the underlying
/// [AppIconPickerViewModel] additionally self-gates so it degrades to an
/// empty picker for anyone else.
class AppIconPickerSection extends StatefulWidget {
  const AppIconPickerSection({required this.viewModel, super.key});

  final AppIconPickerViewModel viewModel;

  @override
  State<AppIconPickerSection> createState() => _AppIconPickerSectionState();
}

class _AppIconPickerSectionState extends State<AppIconPickerSection> {
  AppIconPickerViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();

    unawaited(_viewModel.loadAvailableIcons());
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_viewModel.availableIconIds.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppText.tipScreenAppIconPickerTitle,
              style: AppTheme.sectionHeaderTextStyle,
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            Wrap(
              spacing: Dimensions.standardSpacing,
              runSpacing: Dimensions.standardSpacing,
              children: <Widget>[
                for (final iconId in _viewModel.availableIconIds)
                  _AppIconChoiceChip(
                    iconId: iconId,
                    isSelected: iconId == _viewModel.currentIconId,
                    isApplying: _viewModel.isApplyingIcon,
                    onSelected: () => unawaited(_viewModel.selectIcon(iconId)),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AppIconChoiceChip extends StatelessWidget {
  const _AppIconChoiceChip({
    required this.iconId,
    required this.isSelected,
    required this.isApplying,
    required this.onSelected,
  });

  final String iconId;
  final bool isSelected;
  final bool isApplying;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip.elevated(
      label: Text(_labelFor(iconId)),
      selected: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
      ),
      showCheckmark: false,
      onSelected: isApplying ? null : (_) => onSelected(),
    );
  }

  String _labelFor(String iconId) {
    switch (iconId) {
      case AppIconIds.supporter:
        return AppText.tipScreenAppIconSupporterLabel;
      case AppIconIds.defaultIcon:
      default:
        return AppText.tipScreenAppIconDefaultLabel;
    }
  }
}
