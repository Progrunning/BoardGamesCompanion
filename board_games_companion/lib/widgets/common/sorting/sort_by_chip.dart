import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_styles.dart';
import '../../../common/enums/order_by.dart';
import '../../../models/sort_by.dart';

class SortByChip extends StatelessWidget {
  const SortByChip({
    required this.sortBy,
    required this.onSortByChange,
    super.key,
  });

  final SortBy sortBy;
  final ValueChanged<SortBy> onSortByChange;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        Widget orderByIcon = Container();
        final orderByIconColor =
            sortBy.selected ? AppColors.defaultTextColor : AppColors.accentColor;
        switch (sortBy.orderBy) {
          case OrderBy.Ascending:
            orderByIcon = Icon(Icons.arrow_drop_up, color: orderByIconColor);
            break;
          case OrderBy.Descending:
            orderByIcon = Icon(Icons.arrow_drop_down, color: orderByIconColor);
            break;
        }

        return ChoiceChip.elevated(
          labelStyle: const TextStyle(color: AppColors.defaultTextColor),
          label: Text(
            sortBy.name,
            style: TextStyle(
              color: sortBy.selected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
            ),
          ),
          selected: sortBy.selected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
          ),
          selectedColor: AppColors.accentColor,
          shadowColor: AppColors.shadowColor,
          backgroundColor: AppColors.primaryColor.withAlpha(AppStyles.opacity80Percent),
          avatar: orderByIcon,
          showCheckmark: false,
          onSelected: (isSelected) => onSortByChange(sortBy),
        );
      },
    );
  }
}
