import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../injectable.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';

class PlaythroughsGameSettingsPage extends StatefulWidget {
  const PlaythroughsGameSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlaythroughsGameSettingsPage> createState() => _PlaythroughsGameSettingsPageState();
}

class _PlaythroughsGameSettingsPageState extends State<PlaythroughsGameSettingsPage> {
  late PlaythroughsGameSettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = getIt<PlaythroughsGameSettingsViewModel>();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: BgcSliverHeaderDelegate(
              title: AppText.playthroughsGameSettingsWinningConditionSectionTitle,
            ),
          ),
          _WinningConditionSection(
            winningCondition: viewModel.winningCondition,
            onChange: (GameWinningCondition? winningCondition) async {
              if (winningCondition == null) {
                return;
              }

              await viewModel.updateWinningCondition(winningCondition);
            },
          ),
        ],
      );
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
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
      ),
    );
  }
}
