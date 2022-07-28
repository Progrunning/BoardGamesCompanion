import 'dart:math';

import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/widgets/common/elevated_icon_button.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/order_by.dart';
import '../../extensions/int_extensions.dart';
import '../../models/sort_by.dart';
import '../../stores/board_games_filters_store.dart';
import '../../stores/board_games_store.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';

class GamesFilterPanel extends StatefulWidget {
  const GamesFilterPanel({
    required this.boardGamesFiltersStore,
    Key? key,
  }) : super(key: key);

  final BoardGamesFiltersStore boardGamesFiltersStore;

  @override
  GamesFilterPanelState createState() => GamesFilterPanelState();
}

class GamesFilterPanelState extends State<GamesFilterPanel> {
  late BoardGamesStore boardGamesStore;

  @override
  void initState() {
    super.initState();

    boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.standardSpacing,
          top: Dimensions.doubleStandardSpacing,
          right: Dimensions.standardSpacing,
          bottom: Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          children: <Widget>[
            _SortBy(boardGamesFiltersStore: widget.boardGamesFiltersStore),
            _Filters(
              boardGamesFiltersStore: widget.boardGamesFiltersStore,
              boardGamesStore: boardGamesStore,
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            Align(
              alignment: Alignment.bottomRight,
              child: Observer(
                builder: (_) {
                  return ElevatedIconButton(
                    icon: const Icon(Icons.clear),
                    title: AppText.filterGamesPanelClearFiltersButtonText,
                    color: AppColors.accentColor,
                    onPressed: widget.boardGamesFiltersStore.anyFiltersApplied
                        ? () => _clearFilters(widget.boardGamesFiltersStore)
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

  Future<void> _clearFilters(BoardGamesFiltersStore boardGamesFiltersStore) async {
    await boardGamesFiltersStore.clearFilters();
  }
}

class _SortBy extends StatelessWidget {
  const _SortBy({
    Key? key,
    required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Sort by', style: AppTheme.titleTextStyle),
        Wrap(
          spacing: Dimensions.standardSpacing,
          children: [
            for (final sortByOption in _boardGamesFiltersStore.sortByOptions)
              _SortByChip(
                sortBy: sortByOption,
                boardGamesFiltersStore: _boardGamesFiltersStore,
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
    required this.boardGamesFiltersStore,
    Key? key,
  }) : super(key: key);

  final SortBy sortBy;
  final BoardGamesFiltersStore boardGamesFiltersStore;

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
          onSelected: (isSelected) {
            boardGamesFiltersStore.updateSortBySelection(sortBy);
          },
        );
      },
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.boardGamesFiltersStore,
    required this.boardGamesStore,
    Key? key,
  }) : super(key: key);

  final BoardGamesFiltersStore boardGamesFiltersStore;
  final BoardGamesStore boardGamesStore;

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
        SizedBox(
          height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
          child: Material(
            shadowColor: AppColors.shadowColor,
            elevation: Dimensions.defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
            ),
            child: Container(
              color: AppColors.primaryColor.withAlpha(AppStyles.opacity80Percent),
              child: Observer(
                builder: (_) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _FilterRatingValue(
                        isSelected: boardGamesFiltersStore.filterByRating == null,
                        onRatingSelected: (double? rating) => updateFilterRating(rating),
                      ),
                      _FilterRatingValue(
                        rating: 6.5,
                        onRatingSelected: (double? rating) => updateFilterRating(rating),
                        isSelected: boardGamesFiltersStore.filterByRating == 6.5,
                      ),
                      _FilterRatingValue(
                        rating: 7.5,
                        onRatingSelected: (double? rating) => updateFilterRating(rating),
                        isSelected: boardGamesFiltersStore.filterByRating == 7.5,
                      ),
                      _FilterRatingValue(
                        rating: 8.0,
                        onRatingSelected: (double? rating) => updateFilterRating(rating),
                        isSelected: boardGamesFiltersStore.filterByRating == 8.0,
                      ),
                      _FilterRatingValue(
                        rating: 8.5,
                        onRatingSelected: (double? rating) => updateFilterRating(rating),
                        isSelected: boardGamesFiltersStore.filterByRating == 8.5,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing * 2),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Number of players', style: AppTheme.sectionHeaderTextStyle),
        ),
        if (boardGamesStore.allBoardGames.isNotEmpty)
          _FilterNumberOfPlayersSlider(
            boardGamesFiltersStore: boardGamesFiltersStore,
            boardGamesStore: boardGamesStore,
          ),
      ],
    );
  }

  void updateFilterRating(double? rating) {
    boardGamesFiltersStore.updateFilterByRating(rating);
  }
}

class _FilterNumberOfPlayersSlider extends StatelessWidget {
  const _FilterNumberOfPlayersSlider({
    required this.boardGamesFiltersStore,
    required this.boardGamesStore,
    Key? key,
  }) : super(key: key);

  final BoardGamesFiltersStore boardGamesFiltersStore;
  final BoardGamesStore boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final minNumberOfPlayers = max(
        boardGamesStore.allBoardGames
            .where((boardGameDetails) => boardGameDetails.minPlayers != null)
            .map((boardGameDetails) => boardGameDetails.minPlayers!)
            .reduce(min),
        Constants.minNumberOfPlayers);
    final maxNumberOfPlayers = min(
        boardGamesStore.allBoardGames
            .where((boardGameDetails) => boardGameDetails.maxPlayers != null)
            .map((boardGameDetails) => boardGameDetails.maxPlayers!)
            .reduce(max),
        Constants.maxNumberOfPlayers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(AppText.gameFiltersAnyNumberOfPlayers,
                style: TextStyle(fontSize: Dimensions.smallFontSize)),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  trackShape: const RoundedRectSliderTrackShape(),
                  inactiveTrackColor:
                      AppColors.primaryColorLight.withAlpha(AppStyles.opacity30Percent),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                  tickMarkShape: const RoundSliderTickMarkShape(),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: const TextStyle(fontSize: Dimensions.smallFontSize),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: min(boardGamesFiltersStore.numberOfPlayers?.toDouble() ?? 0,
                      maxNumberOfPlayers.toDouble()),
                  divisions: maxNumberOfPlayers,
                  min: minNumberOfPlayers.toDouble() - 1,
                  max: maxNumberOfPlayers.toDouble(),
                  label: boardGamesFiltersStore.numberOfPlayers.toNumberOfPlayersFilter(),
                  onChanged: (value) {
                    boardGamesFiltersStore.changeNumberOfPlayers(value != 0 ? value.round() : null);
                  },
                  onChangeEnd: (value) {
                    boardGamesFiltersStore.updateNumberOfPlayers(value != 0 ? value.round() : null);
                  },
                  activeColor: AppColors.accentColor,
                ),
              ),
            ),
            Text('$maxNumberOfPlayers', style: const TextStyle(fontSize: Dimensions.smallFontSize)),
          ],
        ),
      ],
    );
  }
}

class _FilterRatingValue extends StatelessWidget {
  const _FilterRatingValue({
    Key? key,
    double? rating,
    required bool isSelected,
    required Function(double?) onRatingSelected,
  })  : _rating = rating,
        _isSelected = isSelected,
        _onRatingSelected = onRatingSelected,
        super(key: key);

  final double? _rating;
  final bool _isSelected;
  final Function(double?) _onRatingSelected;

  @override
  Widget build(BuildContext context) {
    final boardGameRatingHexagon = _rating == null
        ? Center(
            child: Text(
              'Any',
              style: TextStyle(
                color: _isSelected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
              ),
            ),
          )
        : Center(
            child: BoardGameRatingHexagon(
              width: Dimensions.collectionFilterHexagonSize,
              height: Dimensions.collectionFilterHexagonSize,
              rating: _rating,
              fontSize: Dimensions.smallFontSize,
              hexColor: _isSelected ? AppColors.primaryColor : AppColors.accentColor,
            ),
          );

    if (_isSelected) {
      return Expanded(
        child: ElevatedContainer(
          backgroundColor: AppColors.accentColor,
          child: boardGameRatingHexagon,
        ),
      );
    }

    return Expanded(
      child: InkWell(
        child: boardGameRatingHexagon,
        onTap: () => _onRatingSelected(_rating),
      ),
    );
  }
}
