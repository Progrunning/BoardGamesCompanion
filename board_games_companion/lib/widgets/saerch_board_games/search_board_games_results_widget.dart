import 'package:board_games_companion/widgets/saerch_board_games/search_board_games_instructions_widget.dart';
import 'package:flutter/material.dart';

class SaerchBoardGamesResults extends StatelessWidget {
  const SaerchBoardGamesResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SearchBoardGamesInstructions(),
    );
  }
}
