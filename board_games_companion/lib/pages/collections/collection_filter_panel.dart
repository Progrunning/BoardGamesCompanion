import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/order_by.dart';
import '../../common/styles.dart';
import '../../models/sort_by.dart';
import '../../stores/board_games_filters_store.dart';
import '../../stores/board_games_store.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';

class CollectionFilterPanel extends StatefulWidget {
  CollectionFilterPanel({Key key}) : super(key: key);

  @override
  _CollectionFilterPanelState createState() => _CollectionFilterPanelState();
}

class _CollectionFilterPanelState extends State<CollectionFilterPanel> {
  BoardGamesStore boardGamesStore;

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
    return Consumer<BoardGamesFiltersStore>(
      builder: (_, boardGamesFiltersStore, __) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.standardSpacing,
                top: Dimensions.doubleStandardSpacing,
                right: Dimensions.standardSpacing,
                bottom: Dimensions.standardSpacing,
              ),
              child: Column(
                children: <Widget>[
                  _SortBy(
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                  _Filters(
                    boardGamesFiltersStore: boardGamesFiltersStore,
                    boardGamesStore: boardGamesStore,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SortBy extends StatelessWidget {
  const _SortBy({
    Key key,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Sort by',
          style: AppTheme.titleTextStyle,
        ),
        Wrap(
          spacing: Dimensions.standardSpacing,
          children: List<Widget>.generate(
            _boardGamesFiltersStore.sortBy.length,
            (index) {
              return _SortByChip(
                sortBy: _boardGamesFiltersStore.sortBy[index],
                boardGamesFiltersStore: _boardGamesFiltersStore,
              );
            },
          ),
        ),
        SizedBox(
          height: Dimensions.doubleStandardSpacing,
        ),
      ],
    );
  }
}

class _SortByChip extends StatelessWidget {
  const _SortByChip({
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

class _Filters extends StatelessWidget {
  const _Filters({
    @required this.boardGamesFiltersStore,
    @required this.boardGamesStore,
    Key key,
  }) : super(key: key);

  final BoardGamesFiltersStore boardGamesFiltersStore;
  final BoardGamesStore boardGamesStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Filter by',
          style: AppTheme.titleTextStyle,
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Rating',
            style: AppTheme.sectionHeaderTextStyle,
          ),
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        SizedBox(
          height: Dimensions.collectionFilterHexagonSize +
              Dimensions.doubleStandardSpacing,
          child: Material(
            shadowColor: AppTheme.shadowColor,
            elevation: Dimensions.defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Styles.defaultCornerRadius,
              ),
            ),
            child: Container(
              color: AppTheme.primaryColor.withAlpha(
                Styles.opacity80Percent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _FilterRatingAnyValue(
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                  _FilterRatingValue(
                    rating: 6.5,
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                  _FilterRatingValue(
                    rating: 7.5,
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                  _FilterRatingValue(
                    rating: 8.0,
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                  _FilterRatingValue(
                    rating: 8.5,
                    boardGamesFiltersStore: boardGamesFiltersStore,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.doubleStandardSpacing * 2,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Number of players',
            style: AppTheme.sectionHeaderTextStyle,
          ),
        ),
        _FilterNumberOfPlayersSlider(
          boardGamesFiltersStore: boardGamesFiltersStore,
          boardGamesStore: boardGamesStore,
        ),
      ],
    );
  }
}

class _FilterRatingAnyValue extends StatelessWidget {
  const _FilterRatingAnyValue({
    Key key,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    final isSelected = _boardGamesFiltersStore?.filterByRating == null;
    final anyRating = Center(
      child: Text(
        'Any',
        style: TextStyle(
          color: isSelected
              ? AppTheme.defaultTextColor
              : AppTheme.secondaryTextColor,
        ),
      ),
    );

    if (isSelected) {
      return Expanded(
        child: _FilterRatingValueContainer(
          child: anyRating,
        ),
      );
    }
    return Expanded(
      child: InkWell(
        child: anyRating,
        onTap: () {
          _boardGamesFiltersStore.updateFilterByRating(null);
        },
      ),
    );
  }
}

class _FilterNumberOfPlayersSlider extends StatelessWidget {
  const _FilterNumberOfPlayersSlider({
    @required this.boardGamesFiltersStore,
    @required this.boardGamesStore,
    Key key,
  }) : super(key: key);

  final BoardGamesFiltersStore boardGamesFiltersStore;
  final BoardGamesStore boardGamesStore;

  @override
  Widget build(BuildContext context) {
    final minNumberOfPlayers = boardGamesStore.allboardGames
        .where((boardGameDetails) => boardGameDetails.minPlayers != null)
        .map((boardGameDetails) => boardGameDetails.minPlayers)
        ?.reduce(min);
    final maxNumberOfPlayers = boardGamesStore.allboardGames
        .where((boardGameDetails) => boardGameDetails.maxPlayers != null)
        .map((boardGameDetails) => boardGameDetails.maxPlayers)
        ?.reduce(max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Any',
              style: TextStyle(
                fontSize: Dimensions.smallFontSize,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  trackShape: RoundedRectSliderTrackShape(),
                  inactiveTrackColor: AppTheme.primaryColorLight.withAlpha(
                    Styles.opacity30Percent,
                  ),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: TextStyle(
                    fontSize: Dimensions.smallFontSize,
                  ),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value:
                      boardGamesFiltersStore.numberOfPlayers?.toDouble() ?? 0,
                  divisions: maxNumberOfPlayers - 1,
                  min: minNumberOfPlayers.toDouble() - 1,
                  max: maxNumberOfPlayers.toDouble(),
                  label: (boardGamesFiltersStore.numberOfPlayers ?? 0) > 0
                      ? boardGamesFiltersStore.numberOfPlayers?.toString()
                      : 'Any',
                  onChanged: (value) {
                    boardGamesFiltersStore.changeNumberOfPlayers(
                      value != 0 ? value.round() : null,
                    );
                  },
                  onChangeEnd: (value) {
                    boardGamesFiltersStore.updateNumberOfPlayers(
                      value != 0 ? value.round() : null,
                    );
                  },
                  activeColor: AppTheme.accentColor,
                ),
              ),
            ),
            Text(
              '$maxNumberOfPlayers',
              style: TextStyle(
                fontSize: Dimensions.smallFontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterRatingValue extends StatelessWidget {
  const _FilterRatingValue({
    Key key,
    @required double rating,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _rating = rating,
        _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final double _rating;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    final isSelected = _rating == _boardGamesFiltersStore?.filterByRating;
    final boardGameRatingHexagon = BoardGameRatingHexagon(
      width: Dimensions.collectionFilterHexagonSize,
      height: Dimensions.collectionFilterHexagonSize,
      rating: _rating,
      fontSize: Dimensions.smallFontSize,
      hexColor: isSelected ? AppTheme.primaryColor : AppTheme.accentColor,
    );
    final centeredBoardGameRatingHexagon = Center(
      child: boardGameRatingHexagon,
    );

    if (isSelected) {
      final selectionContainer = _FilterRatingValueContainer(
        child: centeredBoardGameRatingHexagon,
      );

      return Expanded(
        child: selectionContainer,
      );
    }

    return Expanded(
      child: InkWell(
        child: centeredBoardGameRatingHexagon,
        onTap: () {
          _boardGamesFiltersStore.updateFilterByRating(_rating);
        },
      ),
    );
  }
}

class _FilterRatingValueContainer extends StatelessWidget {
  const _FilterRatingValueContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Center child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(
          Styles.defaultCornerRadius,
        ),
      ),
      child: child,
    );
  }
}
