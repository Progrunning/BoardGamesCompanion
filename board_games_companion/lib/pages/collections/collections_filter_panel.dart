import 'dart:math';

import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/widgets/common/page_container.dart';
import 'package:board_games_companion/widgets/common/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/dimensions.dart';
import '../../models/sort_by.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_button.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
import '../../widgets/common/sorting/sort_by_chip.dart';
import 'collections_view_model.dart';

class CollectionsFilterPanel extends StatefulWidget {
  const CollectionsFilterPanel({
    required this.viewModel,
    super.key,
  });

  final CollectionsViewModel viewModel;

  @override
  CollectionsFilterPanelState createState() => CollectionsFilterPanelState();
}

class CollectionsFilterPanelState extends State<CollectionsFilterPanel> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Dimensions.doubleStandardSpacing,
          ),
          child: PageContainer(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
              topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: Dimensions.oneAndHalfStandardSpacing),
                const _BottomSheetHandle(),
                const SizedBox(height: Dimensions.oneAndHalfStandardSpacing),
                _SortBySection(gamesViewModel: widget.viewModel),
                const SizedBox(height: Dimensions.standardSpacing),
                _FiltersSection(collectionsViewModel: widget.viewModel),
                const SizedBox(height: Dimensions.standardSpacing),
                Observer(
                  builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: Dimensions.standardSpacing),
                          child: ElevatedIconButton(
                            icon: const Icon(Icons.clear),
                            title: AppText.filterGamesPanelClearFiltersButtonText,
                            color: AppColors.accentColor,
                            onPressed: widget.viewModel.anyFiltersApplied
                                ? () => widget.viewModel.clearFilters()
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
        ),
        child: const SizedBox(
          height: Dimensions.halfStandardSpacing,
          width: Dimensions.trippleStandardSpacing,
        ),
      ),
    );
  }
}

class _SortBySection extends StatelessWidget {
  const _SortBySection({
    required CollectionsViewModel gamesViewModel,
  }) : _gamesViewModel = gamesViewModel;

  final CollectionsViewModel _gamesViewModel;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SectionHeader.titleWithIcon(
            title: 'Sort by',
            icon: const Icon(Icons.sort),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Wrap(
            spacing: Dimensions.standardSpacing,
            children: [
              for (final sortByOption in _gamesViewModel.sortByOptions)
                SortByChip(
                  sortBy: sortByOption,
                  onSortByChange: (SortBy selctedSortBy) =>
                      _gamesViewModel.updateSortBySelection(selctedSortBy),
                )
            ],
          ),
        ],
      );
}

class _FiltersSection extends StatelessWidget {
  const _FiltersSection({
    required this.collectionsViewModel,
  });

  final CollectionsViewModel collectionsViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeader.titleWithIcon(
          title: 'Rating',
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: BgcSegmentedButtonsContainer(
            height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
            backgroundColor: AppColors.primaryColor.withAlpha(AppStyles.opacity80Percent),
            child: Observer(
              builder: (_) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _FilterRatingValue.any(
                      isSelected: collectionsViewModel.filterByRating == null,
                      onRatingSelected: (double? rating) => updateFilterRating(rating),
                    ),
                    _FilterRatingValue.rating(
                      rating: 6.5,
                      onRatingSelected: (double? rating) => updateFilterRating(rating),
                      isSelected: collectionsViewModel.filterByRating == 6.5,
                    ),
                    _FilterRatingValue.rating(
                      rating: 7.5,
                      onRatingSelected: (double? rating) => updateFilterRating(rating),
                      isSelected: collectionsViewModel.filterByRating == 7.5,
                    ),
                    _FilterRatingValue.rating(
                      rating: 8.0,
                      onRatingSelected: (double? rating) => updateFilterRating(rating),
                      isSelected: collectionsViewModel.filterByRating == 8.0,
                    ),
                    _FilterRatingValue.rating(
                      rating: 8.5,
                      onRatingSelected: (double? rating) => updateFilterRating(rating),
                      isSelected: collectionsViewModel.filterByRating == 8.5,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        _NumberOfPlayersFilterSection(collectionsViewModel: collectionsViewModel),
        if (collectionsViewModel.hasAnyboardGamesInCollectionCategories)
          _GameFamilyFilterSection(
            categories: collectionsViewModel.boardGamesInCollectionCategories,
          ),
      ],
    );
  }

  void updateFilterRating(double? rating) {
    collectionsViewModel.updateFilterByRating(rating);
  }
}

class _NumberOfPlayersFilterSection extends StatelessWidget {
  const _NumberOfPlayersFilterSection({
    required this.collectionsViewModel,
  });

  final CollectionsViewModel collectionsViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader.titleWithIcon(
          title: 'Number of players',
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: _FilterNumberOfPlayersSlider(collectionsViewModel: collectionsViewModel),
        ),
      ],
    );
  }
}

// TODO When syncing games via the BGG import the games don't have categories
//      A call to the BGGs API or own API should be done to retrieve all the details
//      This is a bigger task and for now we will only show the categories that are available
class _GameFamilyFilterSection extends StatelessWidget {
  const _GameFamilyFilterSection({
    required this.categories,
  });

  final List<BoardGameCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        SectionHeader.titleWithIcon(
          title: AppText.filterGamesPanelGameFamilySectionHeader,
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: Dimensions.standardSpacing,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              for (final category in categories)
                FilterChip(
                  side: BorderSide.none,
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  backgroundColor: AppColors.primaryColor.withAlpha(
                    AppStyles.opacity80Percent,
                  ),
                  label: Text(
                    category.name,
                    style: const TextStyle(color: AppColors.defaultTextColor),
                  ),
                  // TODO Toggle filter on/off
                  selected: true,
                  onSelected: (bool value) {},
                )
            ],
          ),
        )
      ],
    );
  }
}

class _FilterNumberOfPlayersSlider extends StatelessWidget {
  const _FilterNumberOfPlayersSlider({
    required this.collectionsViewModel,
  });

  final CollectionsViewModel collectionsViewModel;

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
                    value: min(collectionsViewModel.filterByNumberOfPlayers?.toDouble() ?? 0,
                        collectionsViewModel.maxNumberOfPlayers),
                    divisions: collectionsViewModel.maxNumberOfPlayers.toInt(),
                    min: collectionsViewModel.minNumberOfPlayers - 1,
                    max: collectionsViewModel.maxNumberOfPlayers,
                    label: collectionsViewModel.numberOfPlayersSliderValue,
                    onChanged: (value) => collectionsViewModel
                        .changeNumberOfPlayers(value != 0 ? value.round() : null),
                    onChangeEnd: (value) => collectionsViewModel.updateNumberOfPlayersFilter(),
                    activeColor: AppColors.accentColor,
                  );
                },
              ),
            ),
            Observer(
              builder: (_) => Text(
                collectionsViewModel.maxNumberOfPlayers.toStringAsFixed(0),
                style: const TextStyle(fontSize: Dimensions.smallFontSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterRatingValue extends BgcSegmentedButton<double> {
  _FilterRatingValue.any({
    required super.isSelected,
    required Function(double?) onRatingSelected,
  }) : super(
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
    required super.isSelected,
    required Function(double?) onRatingSelected,
  }) : super(
          value: rating,
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
