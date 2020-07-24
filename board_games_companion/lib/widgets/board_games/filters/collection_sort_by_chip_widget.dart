import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

class SortByChip extends StatelessWidget {
  const SortByChip({
    @required sortBy,
    @required boardGamesFiltersStore,
    Key key,
  })  : _sortBy = sortBy,
        _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final SortBy _sortBy;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    Widget avatarIcon = Container();
    switch (_sortBy?.orderBy) {
      case OrderBy.Ascending:
        avatarIcon = Icon(Icons.arrow_drop_up);
        break;
      case OrderBy.Descending:
        avatarIcon = Icon(Icons.arrow_drop_down);
        break;
    }

    return ChoiceChip(
      labelStyle: TextStyle(
        color: AppTheme.defaultTextColor,
      ),
      label: Text(
        _sortBy?.name ?? '',
        style: TextStyle(
          color: (_sortBy?.selected ?? false)
              ? AppTheme.defaultTextColor
              : AppTheme.secondaryTextColor,
        ),
      ),
      selected: _sortBy?.selected ?? false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Styles.defaultCornerRadius,
        ),
      ),
      selectedColor: AppTheme.accentColor,
      shadowColor: AppTheme.shadowColor,
      backgroundColor: AppTheme.primaryColor.withAlpha(
        Styles.opacity80Percent,
      ),
      avatar: avatarIcon,
      onSelected: (isSelected) {
        _boardGamesFiltersStore?.updateSortBySelection(_sortBy);
      },
    );
  }
}
