import 'package:board_games_companion/widgets/common/panel_container.dart';
import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import 'create_board_game_view_model.dart';

class CreateBoardGamePage extends StatelessWidget {
  const CreateBoardGamePage({super.key, required this.viewModel});

  static const String pageRoute = '/createBoardGame';

  final CreateBoardGameViewModel viewModel;

  @override
  Widget build(BuildContext context) => Scaffold(
        // TODO What type of navigation this should be? Perhaps a popup, rather than a regular stacked page?
        appBar: AppBar(
          title: const Text(AppText.createNewGamePageTitle),
        ),
        body: SafeArea(
          child: PanelContainer(
            child: Column(
              children: const [],
            ),
          ),
        ),
      );
}
