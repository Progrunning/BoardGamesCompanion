import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/widgets/about/section_title.dart';
import 'package:flutter/material.dart';

import '../../common/dimensions.dart';

class PlaythroughsGameSettingsPage extends StatefulWidget {
  const PlaythroughsGameSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlaythroughsGameSettingsPage> createState() => _PlaythroughsGameSettingsPageState();
}

class _PlaythroughsGameSettingsPageState extends State<PlaythroughsGameSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [_WinningConditionSection()],
        ),
      ),
    );
  }
}

class _WinningConditionSection extends StatefulWidget {
  const _WinningConditionSection({Key? key}) : super(key: key);

  @override
  State<_WinningConditionSection> createState() => __WinningConditionSectionState();
}

class __WinningConditionSectionState extends State<_WinningConditionSection> {
  GameWinningCondition? _gameWinningCondition = GameWinningCondition.HighestScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(title: AppText.playthroughsGameSettingsWinningConditionSectionTitle),
        RadioListTile<GameWinningCondition>(
          activeColor: AppTheme.accentColor,
          title: const Text(
            AppText.playthroughsGameSettingsWinningConditionHighestScore,
            style: AppTheme.defaultTextFieldStyle,
          ),
          secondary: Icon(Icons.arrow_upward,
              color: _gameWinningCondition == GameWinningCondition.HighestScore
                  ? AppTheme.activeWinningConditionIcon
                  : AppTheme.inactiveBottomTabColor),
          value: GameWinningCondition.HighestScore,
          groupValue: _gameWinningCondition,
          onChanged: (GameWinningCondition? value) {
            setState(() {
              _gameWinningCondition = value;
            });
          },
        ),
        RadioListTile<GameWinningCondition>(
          activeColor: AppTheme.accentColor,
          title: const Text(
            AppText.playthroughsGameSettingsWinningConditionLowestScore,
            style: AppTheme.defaultTextFieldStyle,
          ),
          secondary: Icon(Icons.arrow_downward,
              color: _gameWinningCondition == GameWinningCondition.LowestScore
                  ? AppTheme.activeWinningConditionIcon
                  : AppTheme.inactiveBottomTabColor),
          value: GameWinningCondition.LowestScore,
          groupValue: _gameWinningCondition,
          onChanged: (GameWinningCondition? value) {
            setState(() {
              _gameWinningCondition = value;
            });
          },
        ),
      ],
    );
  }
}
