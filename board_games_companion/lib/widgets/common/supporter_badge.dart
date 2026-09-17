import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

/// A small pill badge marking the current user as a Supporter.
///
/// Purely cosmetic and presentational — it never gates app functionality.
/// Callers decide when to show it, typically gated on
/// `PurchaseService.supporterStatus`/`isSupporter`. Follows the same
/// theming-token pill conventions as `SortByChip`
/// (`lib/widgets/common/sorting/sort_by_chip.dart`).
class SupporterBadge extends StatelessWidget {
  const SupporterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
        vertical: Dimensions.quarterStandardSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius * 4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.star,
            size: Dimensions.smallButtonIconSize,
            color: AppColors.invertedTextColor,
          ),
          const SizedBox(width: Dimensions.quarterStandardSpacing),
          Text(
            AppText.supporterBadgeLabel,
            style: AppTheme.theme.textTheme.bodySmall?.copyWith(
              color: AppColors.invertedTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
