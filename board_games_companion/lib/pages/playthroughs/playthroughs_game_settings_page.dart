import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/about/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';
import '../../common/dimensions.dart';

class PlaythroughsGameSettingsPage extends StatefulWidget {
  const PlaythroughsGameSettingsPage({
    required this.boardGameDetails,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  State<PlaythroughsGameSettingsPage> createState() => _PlaythroughsGameSettingsPageState();
}

class _PlaythroughsGameSettingsPageState extends State<PlaythroughsGameSettingsPage> {
  late PlaythroughsGameSettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );
    viewModel = PlaythroughsGameSettingsViewModel(boardGamesStore);
    viewModel.setBoardGame(widget.boardGameDetails);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WinningConditionSection(
              winningCondition: viewModel.winningCondition,
              onChange: (GameWinningCondition? winningCondition) async {
                if (winningCondition == null) {
                  return;
                }

                await viewModel.updateWinningCondition(winningCondition);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _WinningConditionSection extends StatefulWidget {
  const _WinningConditionSection({
    required this.winningCondition,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final GameWinningCondition winningCondition;
  final Function(GameWinningCondition?) onChange;

  @override
  State<_WinningConditionSection> createState() => __WinningConditionSectionState();
}

class __WinningConditionSectionState extends State<_WinningConditionSection> {
  late GameWinningCondition? _gameWinningCondition = widget.winningCondition;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(title: AppText.playthroughsGameSettingsWinningConditionSectionTitle),
        RadioListTile<GameWinningCondition>(
          activeColor: AppColors.accentColor,
          title: const Text(
            AppText.playthroughsGameSettingsWinningConditionHighestScore,
            style: AppTheme.defaultTextFieldStyle,
          ),
          secondary: Icon(Icons.arrow_upward,
              color: _gameWinningCondition == GameWinningCondition.HighestScore
                  ? AppColors.activeWinningConditionIcon
                  : AppColors.inactiveBottomTabColor),
          value: GameWinningCondition.HighestScore,
          groupValue: _gameWinningCondition,
          onChanged: (GameWinningCondition? value) {
            setState(() {
              _gameWinningCondition = value;
              widget.onChange(_gameWinningCondition);
            });
          },
        ),
        RadioListTile<GameWinningCondition>(
          activeColor: AppColors.accentColor,
          title: const Text(
            AppText.playthroughsGameSettingsWinningConditionLowestScore,
            style: AppTheme.defaultTextFieldStyle,
          ),
          secondary: Icon(Icons.arrow_downward,
              color: _gameWinningCondition == GameWinningCondition.LowestScore
                  ? AppColors.activeWinningConditionIcon
                  : AppColors.inactiveBottomTabColor),
          value: GameWinningCondition.LowestScore,
          groupValue: _gameWinningCondition,
          onChanged: (GameWinningCondition? value) {
            setState(() {
              _gameWinningCondition = value;
              widget.onChange(_gameWinningCondition);
            });
          },
        ),
      ],
    );
  }
}
