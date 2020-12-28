import 'package:board_games_companion/common/app_theme.dart';
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

    return Slider(
      value: _boardGamesFiltersStore.maxNumberOfPlayers.toDouble(),
      divisions: maxNumberOfPlayers - 1,
      min: minNumberOfPlayers.toDouble(),
      max: maxNumberOfPlayers.toDouble(),
      label: _boardGamesFiltersStore.maxNumberOfPlayers.toString(),
      onChanged: (value) {
        print('$value');
        _boardGamesFiltersStore.updateNumberOfPlayers(
          1,
          value.round(),
        );
      },
      activeColor: AppTheme.accentColor,
    );
  }
}
