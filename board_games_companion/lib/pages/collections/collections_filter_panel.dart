import 'dart:math';

import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/widgets/common/elevated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/order_by.dart';
import '../../models/sort_by.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/toggle_buttons/bgc_toggle_button.dart';
import '../../widgets/common/toggle_buttons/bgc_toggle_buttons_container.dart';
import 'collections_view_model.dart';

class CollectionsFilterPanel extends StatefulWidget {
  const CollectionsFilterPanel({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel viewModel;

  @override
  CollectionsFilterPanelState createState() => CollectionsFilterPanelState();
}

class CollectionsFilterPanelState extends State<CollectionsFilterPanel> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.standardSpacing,
          vertical: Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          children: <Widget>[
            _SortBy(gamesViewModel: widget.viewModel),
            _Filters(gamesViewModel: widget.viewModel),
            const SizedBox(height: Dimensions.standardSpacing),
            Align(
              alignment: Alignment.bottomRight,
              child: Observer(
                builder: (_) {
                  return ElevatedIconButton(
                    icon: const Icon(Icons.clear),
                    title: AppText.filterGamesPanelClearFiltersButtonText,
                    color: AppColors.accentColor,
                    onPressed: widget.viewModel.anyFiltersApplied
                        ? () => widget.viewModel.clearFilters()
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortBy extends StatelessWidget {
  const _SortBy({
    Key? key,
    required CollectionsViewModel gamesViewModel,
  })  : _gamesViewModel = gamesViewModel,
        super(key: key);

  final CollectionsViewModel _gamesViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Sort by', style: AppTheme.titleTextStyle),
        Wrap(
          spacing: Dimensions.standardSpacing,
          children: [
            for (final sortByOption in _gamesViewModel.sortByOptions)
              _SortByChip(
                sortBy: sortByOption,
                onSortByChange: (SortBy selctedSortBy) =>
                    _gamesViewModel.updateSortBySelection(selctedSortBy),
              )
          ],
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing),
      ],
    );
  }
}

class _SortByChip extends StatelessWidget {
  const _SortByChip({
    required this.sortBy,
    required this.onSortByChange,
    Key? key,
  }) : super(key: key);

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

        return ChoiceChip(
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
          onSelected: (isSelected) => onSortByChange(sortBy),
        );
      },
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.gamesViewModel,
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel gamesViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Filter by', style: AppTheme.titleTextStyle),
        const SizedBox(height: Dimensions.standardSpacing),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Rating', style: AppTheme.sectionHeaderTextStyle),
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        BgcToggleButtonsContainer(
          height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
          backgroundColor: AppColors.primaryColor.withAlpha(AppStyles.opacity80Percent),
          child: Observer(
            builder: (_) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _FilterRatingValue.any(
                    isSelected: gamesViewModel.filterByRating == null,
                    onRatingSelected: (double? rating) => updateFilterRating(rating),
                  ),
                  _FilterRatingValue.rating(
                    rating: 6.5,
                    onRatingSelected: (double? rating) => updateFilterRating(rating),
                    isSelected: gamesViewModel.filterByRating == 6.5,
                  ),
                  _FilterRatingValue.rating(
                    rating: 7.5,
                    onRatingSelected: (double? rating) => updateFilterRating(rating),
                    isSelected: gamesViewModel.filterByRating == 7.5,
                  ),
                  _FilterRatingValue.rating(
                    rating: 8.0,
                    onRatingSelected: (double? rating) => updateFilterRating(rating),
                    isSelected: gamesViewModel.filterByRating == 8.0,
                  ),
                  _FilterRatingValue.rating(
                    rating: 8.5,
                    onRatingSelected: (double? rating) => updateFilterRating(rating),
                    isSelected: gamesViewModel.filterByRating == 8.5,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing * 2),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Number of players', style: AppTheme.sectionHeaderTextStyle),
        ),
        Observer(builder: (_) {
          if (gamesViewModel.anyBoardGames) {
            return _FilterNumberOfPlayersSlider(gamesViewModel: gamesViewModel);
          }

          return const SizedBox.shrink();
        }),
      ],
    );
  }

  void updateFilterRating(double? rating) {
    gamesViewModel.updateFilterByRating(rating);
  }
}

class _FilterNumberOfPlayersSlider extends StatelessWidget {
  const _FilterNumberOfPlayersSlider({
    required this.gamesViewModel,
    Key? key,
  }) : super(key: key);

  final CollectionsViewModel gamesViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              AppText.gameFiltersAnyNumberOfPlayers,
              style: TextStyle(fontSize: Dimensions.smallFontSize),
            ),
            Expanded(
              child: Observer(
                builder: (_) {
                  return Slider(
                    value: min(gamesViewModel.filterByNumberOfPlayers?.toDouble() ?? 0,
                        gamesViewModel.maxNumberOfPlayers),
                    divisions: gamesViewModel.maxNumberOfPlayers.toInt(),
                    min: gamesViewModel.minNumberOfPlayers - 1,
                    max: gamesViewModel.maxNumberOfPlayers,
                    label: gamesViewModel.numberOfPlayersSliderValue,
                    onChanged: (value) =>
                        gamesViewModel.changeNumberOfPlayers(value != 0 ? value.round() : null),
                    onChangeEnd: (value) => gamesViewModel.updateNumberOfPlayersFilter(),
                    activeColor: AppColors.accentColor,
                  );
                },
              ),
            ),
            Observer(
              builder: (_) => Text(
                gamesViewModel.maxNumberOfPlayers.toStringAsFixed(0),
                style: const TextStyle(fontSize: Dimensions.smallFontSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterRatingValue extends BgcToggleButton<double> {
  _FilterRatingValue.any({
    required bool isSelected,
    required Function(double?) onRatingSelected,
  }) : super(
          isSelected: isSelected,
          onTapped: onRatingSelected,
          child: Center(
            child: Text(
              'Any',
              style: TextStyle(
                color: isSelected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );

  _FilterRatingValue.rating({
    required double rating,
    required bool isSelected,
    required Function(double?) onRatingSelected,
  }) : super(
          value: rating,
          isSelected: isSelected,
          onTapped: onRatingSelected,
          child: Center(
            child: BoardGameRatingHexagon(
              width: Dimensions.collectionFilterHexagonSize,
              height: Dimensions.collectionFilterHexagonSize,
              rating: rating,
              fontSize: Dimensions.smallFontSize,
              hexColor: isSelected ? AppColors.primaryColor : AppColors.accentColor,
            ),
          ),
        );
}
