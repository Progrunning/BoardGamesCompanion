import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
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

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '$minNumberOfPlayers',
          style: TextStyle(
            fontSize: Dimensions.smallFontSize,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: RoundedRectSliderTrackShape(),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: Slider(
              value: _boardGamesFiltersStore.numberOfPlayers.toDouble(),
              divisions: maxNumberOfPlayers - 1,
              min: minNumberOfPlayers.toDouble(),
              max: maxNumberOfPlayers.toDouble(),
              label: _boardGamesFiltersStore.numberOfPlayers.toString(),
              onChanged: (value) {
                _boardGamesFiltersStore.updateNumberOfPlayers(
                  value.round(),
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
    );
  }
}
