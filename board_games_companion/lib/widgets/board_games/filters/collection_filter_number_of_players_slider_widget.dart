import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class CollectionFilterNumberOfPlayersSliderWidget extends StatelessWidget {
  const CollectionFilterNumberOfPlayersSliderWidget({
    @required BoardGamesFiltersStore boardGamesFiltersStore,
    Key key,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );

    final minNumberOfPlayers = boardGamesStore.allboardGames
        .map((boardGameDetails) => boardGameDetails.minPlayers)
        ?.reduce(min);
    final maxNumberOfPlayers = boardGamesStore.allboardGames
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
                      _boardGamesFiltersStore.numberOfPlayers?.toDouble() ?? 0,
                  divisions: maxNumberOfPlayers - 1,
                  min: minNumberOfPlayers.toDouble() - 1,
                  max: maxNumberOfPlayers.toDouble(),
                  label: (_boardGamesFiltersStore.numberOfPlayers ?? 0) > 0
                      ? _boardGamesFiltersStore.numberOfPlayers?.toString()
                      : 'Any',
                  onChanged: (value) {
                    _boardGamesFiltersStore.updateNumberOfPlayers(
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
